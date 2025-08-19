import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_input_decor.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/contact_support.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  String purpose = '';
  final formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: AppBar(
        title: Text(
          S.of(context).support,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            24.ph,
            Image.asset(
              'assets/images/im_support.png',
              width: 122.w,
              height: 136.h,
            ),
            24.ph,
            Divider(
              color: colors(context).scaffoldBackgroundColor,
            ),
            20.ph,
            Text(
              S.of(context).needHelp,
              style: AppTextStyle(context).subTitle.copyWith(fontSize: 24.sp),
            ),
            16.ph,
            Text(
              S.of(context).supportDes,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).bodyText,
            ),
            48.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      onChanged: (v) {
                        purpose = v!;
                      },
                      decoration: AppInputDecor.appInputDecor(context).copyWith(
                          label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).purpose,
                            style: TextStyle(
                              // color: AppStaticColor.labelColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              color: AppStaticColor.redColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      )),
                      items: [
                        DropdownMenuItem(
                          value: "${S.of(context).purpose} - General Question ",
                          child: Text(
                            "${S.of(context).purpose} - General Question",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "${S.of(context).purpose} - Report An Issue",
                          child: Text(
                            "${S.of(context).purpose} - Report An Issue",
                          ),
                        ),
                      ],
                      validator: (value) => value == null
                          ? '${S.of(context).purpose} ${S.of(context).isRequired}'
                          : null,
                    ),
                    24.ph,
                    CustomFormWidget(
                      label: '${S.of(context).writeMessage}..',
                      maxLines: 5,
                      controller: messageController,
                      validator: (val) => validatorWithMessage(
                          message:
                              '${S.of(context).message} ${S.of(context).isRequired}',
                          value: val),
                    ),
                    32.ph,
                    Consumer(builder: (context, ref, _) {
                      return AppButton(
                          title: S.of(context).send,
                          textPaddingVertical: 16.h,
                          showLoading: ref.watch(othersController),
                          titleColor: context.color.surface,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (ref.read(hiveStorageProvider).isGuest()) {
                                EasyLoading.showSuccess(
                                    S.of(context).plzLoginDec);
                                return;
                              }
                              var user =
                                  ref.read(hiveStorageProvider).getUserInfo();
                              ref
                                  .read(othersController.notifier)
                                  .contactSupport(
                                    contactSupport: ContactSupport(
                                      name: user!.name!,
                                      email: user.email!,
                                      subject: purpose,
                                      message: messageController.text,
                                    ),
                                  )
                                  .then((value) {
                                if (value.isSuccess) {
                                  messageController.clear();
                                  EasyLoading.showSuccess(value.message);
                                }
                              });
                            }
                          });
                    }),
                    32.ph,
                    Consumer(
                      builder: (context, ref, _) {
                        return Text(
                          '${S.of(context).orCallUs}: ${ref.read(othersController.notifier).masterModel?.footerContact}',
                          style: AppTextStyle(context).bodyTextSmall,
                        );
                      },
                    ),
                    20.ph
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
