import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/dashboard_nav.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.ph,
          Text(
            S.of(context).supportsLegals.toUpperCase(),
            style: AppTextStyle(context).subTitle.copyWith(
                fontSize: 12.sp, color: colors(context).hintTextColor),
          ),
          16.ph,
          Consumer(builder: (context, ref, _) {
            return SupportButtonCard(
                title: S.of(context).privacyPolicy,
                onTap: () {
                  context.nav.pushNamed(Routes.otherScreen, arguments: {
                    'title': S.of(context).privacy,
                    'body': ref
                        .read(othersController.notifier)
                        .masterModel!
                        .pages
                        .firstWhere(
                            (element) => element.slug == "privacy_policy")
                        .content
                  });
                },
                icon: 'assets/images/privacy.png');
          }),
          // 12.ph,
          // SupportButtonCard(
          //     title: S.of(context).faq,
          //     onTap: () {},
          //     icon: 'assets/images/faq.png'),
          12.ph,
          Consumer(builder: (context, ref, _) {
            return SupportButtonCard(
                title: S.of(context).termsConditions,
                onTap: () {
                  context.nav.pushNamed(Routes.otherScreen, arguments: {
                    'title': S.of(context).termsConditions,
                    'body': ref
                        .read(othersController.notifier)
                        .masterModel!
                        .pages
                        .firstWhere(
                            (element) => element.slug == "terms_and_conditions")
                        .content
                  });
                },
                icon: 'assets/images/t_c.png');
          }),
          12.ph,
          SupportButtonCard(
              title: S.of(context).support,
              onTap: () {
                context.nav.pushNamed(Routes.supportScreen);
              },
              icon: 'assets/images/phonecall.png'),
          12.ph,
          Consumer(builder: (context, ref, _) {
            return ref.read(hiveStorageProvider).isGuest()
                ? Container()
                : GestureDetector(
                    onTap: () {
                      logOutAndDeleteUserDialog(
                          context: context,
                          title: S.of(context).deleteConfirmation,
                          icon: 'assets/svg/ic_delete_account.svg',
                          buttonTitle: S.of(context).delete,
                          ontTap: () async {
                            var res = await ref
                                .read(othersController.notifier)
                                .deleteAccount();
                            if (res.isSuccess) {
                              ref.read(hiveStorageProvider).removeAllData();
                              context.nav.pushNamedAndRemoveUntil(
                                  Routes.dashboard, (route) => false);
                              ref
                                  .read(homeTabControllerProvider.notifier)
                                  .state = 0;
                            }
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/ic_delete_account.svg',
                            height: 24.h,
                            width: 24.h,
                          ),
                          12.pw,
                          Text(
                            S.of(context).deleteAccount,
                            style: AppTextStyle(context).bodyText,
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  );
          }),

          20.ph,
          Consumer(builder: (context, ref, _) {
            return ref.read(hiveStorageProvider).isGuest()
                ? Container()
                : GestureDetector(
                    onTap: () {
                      logOutAndDeleteUserDialog(
                          context: context,
                          title: S.of(context).logoutConfirmation,
                          icon: 'assets/svg/ic_logout.svg',
                          buttonTitle: S.of(context).logOut,
                          ontTap: () {
                            ref.read(hiveStorageProvider).removeAllData();
                            context.nav.pushNamedAndRemoveUntil(
                                Routes.dashboard, (route) => false);
                            ref.read(homeTabControllerProvider.notifier).state =
                                0;
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/ic_logout.svg',
                            height: 24.h,
                            width: 24.h,
                          ),
                          12.pw,
                          Text(
                            S.of(context).logOut,
                            style: AppTextStyle(context).bodyText,
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  );
          }),
          16.ph
        ],
      ),
    );
  }

  logOutAndDeleteUserDialog(
      {required BuildContext context,
      required String icon,
      required String title,
      required String buttonTitle,
      required VoidCallback ontTap}) {
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
              Container(
                width: 64.h,
                height: 64.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStaticColor.redColor.withOpacity(.1)),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    height: 32.h,
                    width: 32.h,
                  ),
                ),
              ),
              20.ph,
              Text(
                title,
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
                        return Consumer(builder: (context, ref, _) {
                          return AppButton(
                            title: buttonTitle,
                            width: double.infinity,
                            showLoading: ref.watch(othersController),
                            buttonColor: AppStaticColor.redColor,
                            titleColor: context.color.surface,
                            textPaddingVertical: 16.h,
                            onTap: ontTap,
                          );
                        });
                      })),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class SupportButtonCard extends StatelessWidget {
  const SupportButtonCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });
  final String title, icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
            border: Border.all(
                color: context.color.surfaceContainerHighest, width: 1),
            borderRadius: BorderRadius.circular(10.w)),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 24.h,
              width: 24.h,
            ),
            12.pw,
            Text(
              title,
              style: AppTextStyle(context).bodyText,
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/svg/ic_arrow_right_svg.svg',
              height: 16.h,
              width: 16.h,
              color: context.color.outlineVariant,
            )
          ],
        ),
      ),
    );
  }
}
