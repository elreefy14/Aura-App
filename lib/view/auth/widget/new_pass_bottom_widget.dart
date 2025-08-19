import 'package:ready_lms/controllers/auth.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/auth/widget/login_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPassBottomWidget extends StatefulWidget {
  const NewPassBottomWidget({
    super.key,
  });
  @override
  State<NewPassBottomWidget> createState() => _NewPassBottomWidgetState();
}

class _NewPassBottomWidgetState extends State<NewPassBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  bool showNewPass = false;
  bool showConfirmPass = false;

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
                          title: S.of(context).createNewPass,
                          body: S.of(context).newPassDes),
                      32.ph,
                      CustomFormWidget(
                        label: S.of(context).createNewPass,
                        obscureText: !showNewPass,
                        controller: newPassController,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              showNewPass = !showNewPass;
                            });
                          },
                          child: Icon(showNewPass
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        validator: (val) => validatorWithMessage(
                            message:
                                '${S.of(context).createNewPass} ${S.of(context).isRequired}',
                            value: val),
                      ),
                      32.ph,
                      CustomFormWidget(
                        label: S.of(context).confirmPassword,
                        obscureText: !showConfirmPass,
                        controller: confirmPassController,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              showConfirmPass = !showConfirmPass;
                            });
                          },
                          child: Icon(showConfirmPass
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        validator: (val) => val == ""
                            ? '${S.of(context).confirmPassword} ${S.of(context).isRequired}'
                            : val != newPassController.text
                                ? S.of(context).passNotMatch
                                : null,
                      ),
                      24.ph,
                      Consumer(builder: (context, ref, _) {
                        return AppButton(
                          title: S.of(context).savePassword,
                          textPaddingVertical: 16.h,
                          showLoading: ref.watch(authController),
                          titleColor: context.color.surface,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              var res = await ref
                                  .read(authController.notifier)
                                  .resetPassword(pass: newPassController.text);
                              if (res.isSuccess) {
                                if (ref.read(hiveStorageProvider).isGuest()) {
                                  context.nav.pop();
                                  ApGlobalFunctions.showBottomSheet(
                                      context: context,
                                      widget: const LoginBottomWidget());
                                } else {
                                  context.nav.pushNamedAndRemoveUntil(
                                      Routes.dashboard, (route) => false);
                                }
                                EasyLoading.showSuccess(res.message);
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
