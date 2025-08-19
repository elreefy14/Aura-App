import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io' show Platform;
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/auth.dart';
import 'package:ready_lms/controllers/checkout.dart';
import 'package:ready_lms/controllers/dashboard_nav.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/auth/widget/login_bottom_widget.dart';
import 'package:ready_lms/view/auth/widget/otp_bottom_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ready_lms/service/iap/apple_iap_service.dart';

import 'widget/body.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  const CheckOutScreen({super.key, required this.courseId});
  final int courseId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckOutScreenViewState();
}

class _CheckOutScreenViewState extends ConsumerState<CheckOutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  Future<void> init() async {
    ref.read(checkoutController.notifier).getNewCourseDetails(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(checkoutController).courseDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).checkOut,
        ),
        leading: IconButton(
            onPressed: () {
              context.nav.pop();
            },
            icon: SvgPicture.asset(
              'assets/svg/ic_arrow_left.svg',
              width: 24.h,
              height: 24.h,
              color: context.color.onSurface,
            )),
      ),
      body: Scaffold(
        body: ref.watch(checkoutController).isLoading || model == null
            ? const ShimmerWidget()
            : const Body(),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
          width: double.infinity,
          color: context.color.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).payableAmount,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(),
                  ),
                  const Spacer(),
                  Text(
                    '${AppConstants.currencySymbol}${ref.watch(checkoutController).totalPrice - ref.watch(checkoutController).couponAmount}',
                    style: AppTextStyle(context).subTitle,
                  ),
                ],
              ),
              8.ph,
              AppButton(
                title: S.of(context).payNow,
                width: double.infinity,
                titleColor: context.color.surface,
                textPaddingVertical: 13.h,
                showLoading: ref.watch(checkoutController).isEnrollLoading,
                onTap: ref.watch(checkoutController).paymentMethod == ''
                    ? null
                    : () async {
                        if (model != null) {
                          if (ref.read(hiveStorageProvider).isGuest()) {
                            EasyLoading.showInfo(S.of(context).plzLoginDec);
                            ApGlobalFunctions.showBottomSheet(
                                context: context,
                                widget: const LoginBottomWidget());
                            return;
                          }
                          double totalAmount =
                              ref.watch(checkoutController).totalPrice -
                                  ref.watch(checkoutController).couponAmount;
                          var res = await ref
                              .read(checkoutController.notifier)
                              .enrollCourseById(
                                id: model.course.id,
                                totalAmount: totalAmount,
                              );
                          if (res.isSuccess) {
                            final resp = res.response?.toString() ?? '';
                            if (resp.startsWith('iap://') && Platform.isIOS) {
                              // Extract product_id
                              final uri = Uri.tryParse(resp);
                              final productId = uri?.queryParameters['product_id'];
                              if (productId == null || productId.isEmpty) {
                                EasyLoading.showError('Invalid IAP product');
                                return;
                              }
                              EasyLoading.show(status: 'Purchasing…');
                              final iapRes = await ref
                                  .read(appleIapServiceProvider)
                                  .purchaseCourse(
                                    courseId: model.course.id,
                                    productId: productId,
                                  );
                              EasyLoading.dismiss();
                              if (iapRes.isSuccess) {
                                paymentSuccessDialog(context: context, id: 0);
                              } else {
                                EasyLoading.showError(iapRes.message);
                              }
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return PayWithWeb(
                                  url: resp,
                                );
                              }));
                            }
                          } else {
                            if (res.message == 'Account activation required') {
                              activeAccountDialog(context: context);
                            }
                          }
                        }
                      },
              )
            ],
          ),
        ),
      ),
    );
  }

  activeAccountDialog({
    required BuildContext context,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.w))),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please Active Your Account",
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyText.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    color: AppStaticColor.redColor),
              ),
              20.ph,
              SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: AppOutlineButton(
                        title: S.of(context).cancel,
                        width: double.infinity,
                        buttonColor: context.color.surface,
                        titleColor: AppStaticColor.redColor,
                        textPaddingVertical: 16.h,
                        borderRadius: 12.r,
                        onTap: () => context.nav.pop(),
                      )),
                      12.pw,
                      Expanded(child: Consumer(builder: (context, ref, _) {
                        return AppButton(
                          title: "Active",
                          width: double.infinity,
                          showLoading: ref.watch(authController),
                          titleColor: context.color.surface,
                          textPaddingVertical: 16.h,
                          onTap: () async {
                            var res = await ref
                                .read(authController.notifier)
                                .activeAccountRequest();
                            if (res.isSuccess) {
                              context.nav.pop();
                              ApGlobalFunctions.showBottomSheet(
                                  context: context,
                                  widget: OTPBottomWidget(
                                    senderText: ref
                                            .read(hiveStorageProvider)
                                            .getUserInfo()
                                            ?.email ??
                                        "Demo",
                                  ));
                            } else {
                              EasyLoading.showError(res.message);
                            }
                          },
                        );
                      })),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void paymentSuccessDialog({required BuildContext context, required int id}) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.w))),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.h,
                height: 60.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppStaticColor.greenColor),
                child: Center(
                  child: Icon(
                    Icons.done_rounded,
                    color: context.color.surface,
                    size: 32.h,
                  ),
                ),
              ),
              16.ph,
              Text(
                S.of(context).paymentSuccessful,
                textAlign: TextAlign.center,
                style: AppTextStyle(context).title.copyWith(
                      fontSize: 22.sp,
                    ),
              ),
              16.ph,
              Text(
                '${S.of(context).paymentDes} ${AppConstants.appName}',
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyTextSmall,
              ),
              20.ph,
              AppButton(
                title: S.of(context).startLearning,
                width: double.infinity,
                titleColor: context.color.surface,
                textPaddingVertical: 13.h,
                onTap: () {
                  context.nav.pushNamedAndRemoveUntil(
                      Routes.dashboard, (route) => false);
                  ref.read(homeTabControllerProvider.notifier).state = 1;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PayWithWeb extends ConsumerStatefulWidget {
  final String url;

  const PayWithWeb({super.key, required this.url});

  @override
  _PayWithWebState createState() => _PayWithWebState();
}

class _PayWithWebState extends ConsumerState<PayWithWeb> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optionally, handle the loading progress here.
          },
      onPageStarted: (String url) {
      final lowerUrl = url.toLowerCase();
      final isSuccess = lowerUrl.contains('payment/success') ||
        lowerUrl.contains('payment/success?') ||
        lowerUrl.contains('status=success') ||
        lowerUrl.contains('paymob') &&
          (lowerUrl.contains('success=true') ||
            lowerUrl.contains('txn_success') ||
            lowerUrl.contains('success'));
      final isCancel = lowerUrl.contains('payment/cancel') ||
        lowerUrl.contains('status=failed') ||
        lowerUrl.contains('status=cancel') ||
        lowerUrl.contains('canceled') ||
        lowerUrl.contains('cancelled') ||
        (lowerUrl.contains('paymob') &&
          (lowerUrl.contains('success=false') ||
            lowerUrl.contains('failed') ||
            lowerUrl.contains('error')));
      if (isSuccess) {
              Navigator.pop(context); // Close the dialog.
              paymentSuccessDialog(
                  context: context, id: 123); // Show success dialog.
            }
      if (isCancel) {
              Navigator.pop(context); // Close the dialog.
              // Optionally, show a failure message.
              // showSnackBar(context, 'Payment Failed');
            }
          },
          onPageFinished: (String url) {
            // Optionally, handle when the page finishes loading.
          },
          onWebResourceError: (WebResourceError error) {
            // Handle errors here if needed.
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate; // Allow navigation.
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  paymentSuccessDialog({required BuildContext context, required int id}) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.w))),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.h,
                height: 60.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppStaticColor.greenColor),
                child: Center(
                  child: Icon(
                    Icons.done_rounded,
                    color: context.color.surface,
                    size: 32.h,
                  ),
                ),
              ),
              16.ph,
              Text(
                S.of(context).paymentSuccessful,
                textAlign: TextAlign.center,
                style: AppTextStyle(context).title.copyWith(
                      fontSize: 22.sp,
                    ),
              ),
              // 20.ph,
              // Text(
              //   '${S.of(context).yourOrderID}: $id',
              //   textAlign: TextAlign.center,
              //   style: AppTextStyle(context)
              //       .bodyTextSmall
              //       .copyWith(color: context.color.inverseSurface),
              // ),
              16.ph,
              Text(
                '${S.of(context).paymentDes} ${AppConstants.appName}',
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyTextSmall,
              ),
              20.ph,
              AppButton(
                title: S.of(context).startLearning,
                width: double.infinity,
                titleColor: context.color.surface,
                textPaddingVertical: 13.h,
                onTap: () {
                  context.nav.pushNamedAndRemoveUntil(
                      Routes.dashboard, (route) => false);
                  ref.read(homeTabControllerProvider.notifier).state = 1;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
