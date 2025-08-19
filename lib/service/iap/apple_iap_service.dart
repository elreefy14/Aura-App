import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/utils/api_client.dart';

/// Lightweight Apple IAP facade
/// Contract:
/// - input: productId (from AppConstants.appleProductIds)
/// - success: completes purchase and notifies backend via /enroll/<id>?payment_gateway=apple_iap&transaction_id=...&receipt=...
/// - output: CommonResponse(isSuccess, message)
class AppleIapService {
  AppleIapService(this.ref);
  final Ref ref;

  final InAppPurchase _iap = InAppPurchase.instance;

  Future<CommonResponse> purchaseCourse({
    required int courseId,
    required String productId,
  }) async {
    if (!Platform.isIOS) {
      return CommonResponse(isSuccess: false, message: 'IAP is only for iOS.');
    }

    final available = await _iap.isAvailable();
    if (!available) {
      return CommonResponse(isSuccess: false, message: 'App Store unavailable');
    }

    try {
      // Ensure product exists
      final response = await _iap.queryProductDetails({productId});
      if (response.productDetails.isEmpty) {
        return CommonResponse(isSuccess: false, message: 'Product not found');
      }
      final product = response.productDetails.first;

      // Wait for purchase updates and notify backend when completed.
      final completer = Completer<CommonResponse>();
      late final StreamSubscription<List<PurchaseDetails>> sub;
      sub = _iap.purchaseStream.listen((purchases) async {
        for (final p in purchases) {
          if (p.productID != productId) continue;
          switch (p.status) {
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              try {
                // iOS receipt payload (base64)
                final receipt = p.verificationData.serverVerificationData;
                final transactionId = p.purchaseID; // may be null on iOS

                // Notify backend using existing enroll endpoint with apple_iap gateway.
                final api = ref.read(apiClientProvider);
                final resp = await api.get(
                  AppConstants.purchase + courseId.toString(),
                  query: <String, dynamic>{
                    'payment_gateway': AppConstants.appleIapGateway,
                    'product_id': productId,
                    if (transactionId != null) 'transaction_id': transactionId,
                    'receipt': receipt,
                  },
                );

                // Complete the purchase on device (consumption not needed for non-consumable)
                if (p.pendingCompletePurchase) {
                  await _iap.completePurchase(p);
                }

                if (!completer.isCompleted) {
                  final ok = resp.statusCode == 201 || resp.statusCode == 200;
                  completer.complete(
                    CommonResponse(
                      isSuccess: ok,
                      message: resp.data is Map && (resp.data['message'] != null)
                          ? resp.data['message'].toString()
                          : (ok ? 'Purchase successful' : 'Purchase failed'),
                      response: ok ? (resp.data is Map ? resp.data['data'] : null) : null,
                    ),
                  );
                }
              } catch (e, st) {
                debugPrint('IAP backend notify error: $e\n$st');
                if (!completer.isCompleted) {
                  completer.complete(
                    CommonResponse(isSuccess: false, message: e.toString()),
                  );
                }
              } finally {
                await sub.cancel();
              }
              break;
            case PurchaseStatus.error:
              if (!completer.isCompleted) {
                completer.complete(
                  CommonResponse(
                    isSuccess: false,
                    message: p.error?.message ?? 'Purchase error',
                  ),
                );
              }
              await sub.cancel();
              break;
            case PurchaseStatus.canceled:
              if (!completer.isCompleted) {
                completer.complete(
                  CommonResponse(isSuccess: false, message: 'Purchase cancelled'),
                );
              }
              await sub.cancel();
              break;
            case PurchaseStatus.pending:
              // Ignore; wait for a terminal status
              break;
          }
        }
      });

      // Kick off purchase
      final purchaseParam = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      // Return when stream completes a terminal result or after timeout
      return completer.future.timeout(
        const Duration(seconds: 60),
        onTimeout: () => CommonResponse(
          isSuccess: false,
          message: 'Purchase timeout',
        ),
      );
    } catch (e, st) {
      debugPrint('IAP error: $e\n$st');
      return CommonResponse(isSuccess: false, message: e.toString());
    }
  }
}

final appleIapServiceProvider = Provider((ref) => AppleIapService(ref));
