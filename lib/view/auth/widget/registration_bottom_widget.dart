import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/auth.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/authentication/signup_credential.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/auth/widget/login_bottom_widget.dart';
import 'package:ready_lms/view/auth/widget/otp_bottom_widget.dart';
import 'package:ready_lms/view/other/other_secreen.dart';

class RegistrationBottomWidget extends StatefulWidget {
  const RegistrationBottomWidget({
    super.key,
  });
  @override
  State<RegistrationBottomWidget> createState() =>
      _RegistrationBottomWidgetState();
}

class _RegistrationBottomWidgetState extends State<RegistrationBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool showPass = false;
  bool checkboxValue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                            title: S.of(context).signUp,
                            body: S.of(context).loginHeaderText),
                        32.ph,
                        CustomFormWidget(
                          // hint: 'Email or Phone',
                          label: S.of(context).fullName,
                          controller: nameController,
                          validator: (val) => validatorWithMessage(
                              message:
                                  '${S.of(context).fullName} ${S.of(context).isRequired}',
                              value: val),
                        ),
                        32.ph,
                        CustomFormWidget(
                          // hint: 'Email or Phone',
                          label: S.of(context).phoneNumber,
                          keyboardType: TextInputType.number,
                          controller: mobileController,
                          validator: (val) => validatorWithMessage(
                              message:
                                  '${S.of(context).phoneNumber} ${S.of(context).isRequired}',
                              value: val),
                        ),
                        32.ph,
                        CustomFormWidget(
                          // hint: 'Email or Phone',
                          label: S.of(context).email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => validatorWithMessage(
                              isEmail: true,
                              message:
                                  '${S.of(context).email} ${S.of(context).isRequired}',
                              value: val),
                        ),
                        32.ph,
                        CustomFormWidget(
                          label: S.of(context).createPassword,
                          obscureText: !showPass,
                          controller: newPassController,
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
                        24.ph,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    colors(context).scaffoldBackgroundColor,
                              ),
                              child: Checkbox(
                                  value: checkboxValue,
                                  onChanged: (newValue) => setState(() {
                                        checkboxValue = newValue!;
                                      }),
                                  activeColor: colors(context).primaryColor,
                                  checkColor: Colors.white,
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 1.0,
                                        color: colors(context)
                                            .hintTextColor!
                                            .withOpacity(AppConstants
                                                .hintColorBorderOpacity)),
                                  )),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "${S.of(context).accept}  ",
                                          style: AppTextStyle(context)
                                              .bodyText
                                              .copyWith(fontSize: 12.sp)),
                                      TextSpan(
                                        text: S.of(context).termsConditions,
                                        style: AppTextStyle(context)
                                            .bodyText
                                            .copyWith(
                                                fontSize: 12.sp,
                                                color: colors(context)
                                                    .primaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await showDialog(
                                              context: context,
                                              builder: (context) => Consumer(
                                                  builder: (context, ref, _) {
                                                return OtherScreen(
                                                    title: 'Terms Conditions',
                                                    body: ref
                                                        .read(othersController
                                                            .notifier)
                                                        .masterModel!
                                                        .pages
                                                        .firstWhere((element) =>
                                                            element.slug ==
                                                            "terms_and_conditions")
                                                        .content);
                                              }),
                                            );
                                          },
                                      ),
                                      TextSpan(
                                          text: ' and ',
                                          style: AppTextStyle(context)
                                              .bodyText
                                              .copyWith(fontSize: 12.sp)),
                                      TextSpan(
                                          text: S.of(context).privacy,
                                          style: AppTextStyle(context)
                                              .bodyText
                                              .copyWith(
                                                  fontSize: 12.sp,
                                                  color: colors(context)
                                                      .primaryColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) => Consumer(
                                                    builder: (context, ref, _) {
                                                  return OtherScreen(
                                                      title: 'Privacy Policy',
                                                      body: ref
                                                          .read(othersController
                                                              .notifier)
                                                          .masterModel!
                                                          .pages
                                                          .firstWhere((element) =>
                                                              element.slug ==
                                                              "privacy_policy")
                                                          .content);
                                                }),
                                              );
                                            }),
                                      TextSpan(
                                          text: ' of ${AppConstants.appName}',
                                          style: AppTextStyle(context)
                                              .bodyText
                                              .copyWith(fontSize: 12.sp)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        12.ph,
                        Consumer(builder: (context, ref, _) {
                          return AppButton(
                            title: S.of(context).cContinue,
                            textPaddingVertical: 16.h,
                            titleColor: context.color.surface,
                            showLoading: ref.watch(authController),
                            onTap: checkboxValue
                                ? () async {
                                    if (formKey.currentState!.validate()) {
                                      var res = await ref
                                          .read(authController.notifier)
                                          .signUp(SignUpCredential(
                                              firstName: nameController.text,
                                              email: emailController.text,
                                              phoneNumber:
                                                  mobileController.text,
                                              password: newPassController.text,
                                              confirmPassword:
                                                  newPassController.text));
                                      if (res.isSuccess) {
                                        context.nav.pop();
                                        ApGlobalFunctions.showBottomSheet(
                                            context: context,
                                            widget: OTPBottomWidget(
                                              senderText: emailController.text,
                                            ));
                                      } else {
                                        EasyLoading.showError(res.message);
                                      }
                                    }
                                  }
                                : null,
                          );
                        }),
                        24.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).allReadyHaveAccount,
                              style: AppTextStyle(context).bodyTextSmall,
                            ),
                            4.pw,
                            GestureDetector(
                              onTap: () {
                                context.nav.pop();
                                ApGlobalFunctions.showBottomSheet(
                                    context: context,
                                    widget: const LoginBottomWidget());
                              },
                              child: Text(
                                S.of(context).login,
                                style: AppTextStyle(context)
                                    .bodyTextSmall
                                    .copyWith(
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
      ),
    );
  }
}
