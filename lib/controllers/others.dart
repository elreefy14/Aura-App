import 'package:ready_lms/config/app_constants.dart';
import 'dart:io' show Platform;
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/contact_support.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/master.dart';
import 'package:ready_lms/service/more_tab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherController extends StateNotifier<bool> {
  final Ref ref;
  OtherController(this.ref) : super(false);
  MasterModel? masterModel;
  Future<CommonResponse> makeReview(
      {required int id, required Map<String, dynamic> data}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(otherServiceProvider).makeReview(id: id, data: data);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
          isSuccess: isSuccess,
          message: response.data['message'],
          response: isSuccess
              ? SubmittedReview.fromJson(response.data['data']['review'])
              : null);
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> contactSupport(
      {required ContactSupport contactSupport}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref
          .read(otherServiceProvider)
          .contactSupport(contactSupport: contactSupport);
      state = false;
      if (response.statusCode == 201) {
        isSuccess = true;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> deleteAccount() async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref.read(otherServiceProvider).deleteAccount();
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> getMasterData() async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref.read(otherServiceProvider).masterCall();
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
        masterModel = MasterModel.fromJson(response.data['data']['master']);
        AppConstants.currencySymbol = masterModel?.currencySymbol ?? '€';
        AppConstants.appName = masterModel!.name;

        // Optionally inject Paymob gateway into UI if backend doesn't list it yet
        if (AppConstants.enablePaymob) {
          final hasPaymob = masterModel!.paymentMethods.any(
              (pm) => pm.gateway.toLowerCase() == AppConstants.paymobGateway);
          if (!hasPaymob) {
            masterModel!.paymentMethods.add(
              PaymentMethods(
                name: AppConstants.paymobName,
                gateway: AppConstants.paymobGateway,
                isActive: 1,
                logo: AppConstants.paymobLogoUrl,
              ),
            );
          }
        }

        // Inject Apple IAP on iOS when enabled
        if (AppConstants.enableAppleIAP && Platform.isIOS) {
          final hasApple = masterModel!.paymentMethods.any(
              (pm) => pm.gateway.toLowerCase() == AppConstants.appleIapGateway);
          if (!hasApple) {
            masterModel!.paymentMethods.add(
              PaymentMethods(
                name: AppConstants.appleIapName,
                gateway: AppConstants.appleIapGateway,
                isActive: 1,
                logo: AppConstants.appleIapLogoUrl,
              ),
            );
          }
        }
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      masterModel = null;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }
}

final othersController =
    StateNotifierProvider<OtherController, bool>((ref) => OtherController(ref));
