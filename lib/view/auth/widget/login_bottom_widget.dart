import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/auth.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/auth/widget/recover_pass_bottom_widget.dart';
import 'package:ready_lms/view/auth/widget/registration_bottom_widget.dart';

class LoginBottomWidget extends StatefulWidget {
  const LoginBottomWidget({
    super.key,
  });
  @override
  State<LoginBottomWidget> createState() => _LoginBottomWidgetState();
}

class _LoginBottomWidgetState extends State<LoginBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    passwordController.text = 'secret@123';
    idController.text = 'user@readylms.com';
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
                          title: S.of(context).login,
                          body: S.of(context).loginHeaderText),
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
                      32.ph,
                      CustomFormWidget(
                        label: S.of(context).password,
                        obscureText: !showPass,
                        controller: passwordController,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          child: Icon(showPass
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        validator: (val) => validatorWithMessage(
                            message:
                                '${S.of(context).password} ${S.of(context).isRequired}',
                            value: val),
                      ),
                      16.ph,
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            context.nav.pop();
                            ApGlobalFunctions.showBottomSheet(
                                context: context,
                                widget: const RecoverPassBottomWidget());
                          },
                          child: Text(
                            S.of(context).forgetPassword,
                            style: AppTextStyle(context)
                                .bodyTextSmall
                                .copyWith(color: context.color.primary),
                          ),
                        ),
                      ),
                      24.ph,
                      Consumer(builder: (context, ref, _) {
                        return AppButton(
                          title: S.of(context).login,
                          textPaddingVertical: 16.h,
                          titleColor: context.color.surface,
                          showLoading: ref.watch(authController),
                          onTap: passwordController.text != '' &&
                                  idController.text != ''
                              ? () async {
                                  if (formKey.currentState!.validate()) {
                                    var res = await ref
                                        .read(authController.notifier)
                                        .login(
                                            contact: idController.text,
                                            password: passwordController.text);
                                    if (res.isSuccess) {
                                      EasyLoading.showSuccess(res.message);
                                      ref
                                          .read(hiveStorageProvider)
                                          .setFirstOpenValue(value: false);
                                      context.nav.pushNamedAndRemoveUntil(
                                          Routes.dashboard, (route) => false);
                                    } else {
                                      EasyLoading.showError(
                                          S.of(context).loginFailDes);
                                    }
                                  }
                                }
                              : null,
                        );
                      }),
                      24.ph,
                      Row(
                        children: [
                          Text(
                            S.of(context).dontHaveAccount,
                            style: AppTextStyle(context).bodyTextSmall,
                          ),
                          4.pw,
                          GestureDetector(
                            onTap: () {
                              context.nav.pop();
                              ApGlobalFunctions.showBottomSheet(
                                  context: context,
                                  widget: const RegistrationBottomWidget());
                            },
                            child: Text(
                              S.of(context).signUp,
                              style:
                                  AppTextStyle(context).bodyTextSmall.copyWith(
                                        color: context.color.primary,
                                        decorationColor: context.color.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                            ),
                          )
                        ],
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
