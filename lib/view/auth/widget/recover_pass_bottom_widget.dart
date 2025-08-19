import 'package:ready_lms/controllers/auth.dart';
import 'package:ready_lms/view/auth/widget/otp_bottom_widget.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecoverPassBottomWidget extends StatefulWidget {
  const RecoverPassBottomWidget({
    super.key,
    this.senderText = '',
  });
  final String? senderText;
  @override
  State<RecoverPassBottomWidget> createState() =>
      _RecoverPassBottomWidgetState();
}

class _RecoverPassBottomWidgetState extends State<RecoverPassBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    idController.text = widget.senderText!;
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
                          title: S.of(context).recoverPassword,
                          body: S.of(context).passRecoverDes),
                      32.ph,
                      CustomFormWidget(
                        // hint: 'Email or Phone',
                        label: S.of(context).emailOrPhone,
                        controller: idController,
                        validator: (val) => validatorWithMessage(
                            message:
                                '${S.of(context).emailOrPhone} ${S.of(context).isRequired}',
                            value: val),
                      ),
                      24.ph,
                      Consumer(builder: (context, ref, _) {
                        return AppButton(
                          title: S.of(context).proceedNext,
                          textPaddingVertical: 16.h,
                          showLoading: ref.watch(authController),
                          titleColor: context.color.surface,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              var res = await ref
                                  .read(authController.notifier)
                                  .resetPassRequest(id: idController.text);
                              if (res.isSuccess) {
                                context.nav.pop();
                                ApGlobalFunctions.showBottomSheet(
                                    context: context,
                                    widget: OTPBottomWidget(
                                      senderText: idController.text,
                                      isFromResetPass: true,
                                    ));
                              } else {
                                EasyLoading.showError(res.message);
                              }
                            }
                          },
                        );
                      }),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
