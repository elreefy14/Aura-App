import 'dart:async';

import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/auth.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:ready_lms/view/auth/widget/new_pass_bottom_widget.dart';
import 'package:ready_lms/view/auth/widget/pin_put.dart';
import 'package:ready_lms/view/auth/widget/recover_pass_bottom_widget.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OTPBottomWidget extends ConsumerStatefulWidget {
  const OTPBottomWidget({
    super.key,
    required this.senderText,
    this.isFromResetPass = false,
  });
  final String senderText;
  final bool isFromResetPass;
  @override
  ConsumerState<OTPBottomWidget> createState() => _OTPBottomWidgetState();
}

class _OTPBottomWidgetState extends ConsumerState<OTPBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController pinCodeController = TextEditingController();
  final timeCounter = StateProvider<int>((ref) {
    return 60;
  });
  final isResendOtp = StateProvider<bool>((ref) {
    return false;
  });
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    pinCodeController.text = ref.read(apiClientProvider).activeCode == null
        ? ''
        : ref.read(apiClientProvider).activeCode.toString();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (ref.read(timeCounter) == 0) {
        timer.cancel();
      } else {
        ref.read(timeCounter.notifier).state--;
      }
    });
  }

  resendOtpRequest() async {
    ref.read(isResendOtp.notifier).state = true;
    await ref
        .read(authController.notifier)
        .resetPassRequest(id: widget.senderText)
        .then((value) {
      ref.read(timeCounter.notifier).state = 60;
      startTimer();

      pinCodeController.text = ref.read(apiClientProvider).activeCode == null
          ? ''
          : ref.read(apiClientProvider).activeCode.toString();
    });
    ref.read(isResendOtp.notifier).state = false;
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      BottomBarHeader(
                          onTap: () {
                            context.nav.pop();
                          },
                          onTapEdit: widget.isFromResetPass
                              ? () {
                                  context.nav.pop();
                                  ApGlobalFunctions.showBottomSheet(
                                      context: context,
                                      widget: RecoverPassBottomWidget(
                                        senderText: widget.senderText,
                                      ));
                                }
                              : null,
                          title: S.of(context).enterOTP,
                          body:
                              '${S.of(context).verifyOTPDes}${widget.senderText}'),
                      32.ph,
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: PinPutWidget(
                          pinCodeController: pinCodeController,
                          onCompleted: (pin) {},
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      24.ph,
                      Consumer(builder: (context, ref, _) {
                        return AppButton(
                          title: S.of(context).confirmOTP,
                          textPaddingVertical: 16.h,
                          titleColor: context.color.surface,
                          showLoading: ref.watch(authController) &&
                              !ref.watch(isResendOtp),
                          onTap: pinCodeController.length == 4
                              ? () async {
                                  if (formKey.currentState!.validate()) {
                                    if (widget.isFromResetPass) {
                                      var res = await ref
                                          .read(authController.notifier)
                                          .validateOtpForResetPass(
                                              id: widget.senderText,
                                              otp: pinCodeController.text);
                                      if (res.isSuccess) {
                                        context.nav.pop();
                                        ApGlobalFunctions.showBottomSheet(
                                            context: context,
                                            widget:
                                                const NewPassBottomWidget());
                                      } else {
                                        EasyLoading.showError(res.message);
                                      }
                                    } else {
                                      var res = await ref
                                          .read(authController.notifier)
                                          .activeAccountByOtp(
                                              otp: pinCodeController.text);
                                      if (res.isSuccess) {
                                        EasyLoading.showSuccess(res.message);
                                        context.nav.pushNamedAndRemoveUntil(
                                            Routes.dashboard, (route) => false);
                                        // context.nav.pop();
                                        // ApGlobalFunctions.showBottomSheet(
                                        //     context: context,
                                        //     widget: NewPassBottomWidget());
                                      } else {
                                        EasyLoading.showError(res.message);
                                      }
                                    }
                                  }
                                }
                              : null,
                        );
                      }),
                      24.ph,
                      ref.watch(timeCounter) == 0
                          ? ref.watch(isResendOtp)
                              ? Center(
                                  child: SizedBox(
                                    width: 18.h,
                                    height: 18.h,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          context.color.primary),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      resendOtpRequest();
                                    },
                                    child: Text(
                                      S.of(context).resendCode,
                                    ),
                                  ),
                                )
                          : Center(
                              child: Text(
                                "${S.of(context).resend} 00:${ref.watch(timeCounter)} ${S.of(context).sec}",
                                style: AppTextStyle(context)
                                    .bodyTextSmall
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                      if (!widget.isFromResetPass) 8.ph,
                      if (!widget.isFromResetPass)
                        GestureDetector(
                          onTap: () {
                            context.nav.pushNamedAndRemoveUntil(
                                Routes.dashboard, (route) => false);
                          },
                          child: Text(
                            S.of(context).skip,
                            style: AppTextStyle(context).bodyTextSmall.copyWith(
                                color: context.color.primary,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
