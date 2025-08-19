import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/auth.dart';
import 'package:ready_lms/generated/l10n.dart';

import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/auth/widget/recover_pass_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePassBottomWidget extends StatefulWidget {
  const ChangePassBottomWidget({
    super.key,
  });
  @override
  State<ChangePassBottomWidget> createState() => _ChangePassBottomWidgetState();
}

class _ChangePassBottomWidgetState extends State<ChangePassBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool showCurrentPass = false;
  bool showNewPass = false;
  bool showConfirmPass = false;

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
                            title:
                                '${S.of(context).change} ${S.of(context).password}',
                            body: S.of(context).loginHeaderText),
                        32.ph,
                        CustomFormWidget(
                          // hint: 'Email or Phone',
                          label: S.of(context).currentPass,
                          obscureText: !showCurrentPass,

                          controller: oldPasswordController,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                showCurrentPass = !showCurrentPass;
                              });
                            },
                            child: Icon(showCurrentPass
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          validator: (val) => validatorWithMessage(
                              message:
                                  '${S.of(context).currentPass} ${S.of(context).isRequired}',
                              value: val),
                        ),
                        32.ph,
                        CustomFormWidget(
                          label: S.of(context).createNewPass,
                          obscureText: !showNewPass,
                          controller: newPasswordController,
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
                          controller: confirmPasswordController,
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
                              : val != newPasswordController.text
                                  ? S.of(context).passNotMatch
                                  : null,
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
                              title: S.of(context).changePassword,
                              textPaddingVertical: 16.h,
                              showLoading: ref.watch(authController),
                              titleColor: context.color.surface,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  ref
                                      .read(authController.notifier)
                                      .updatePassword(
                                          oldPass: oldPasswordController.text,
                                          newPass: newPasswordController.text)
                                      .then((value) {
                                    if (value.isSuccess) {
                                      context.nav.pop();
                                    }
                                    EasyLoading.showSuccess(value.message);
                                  });
                                }
                              });
                        }),
                        24.ph,
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
