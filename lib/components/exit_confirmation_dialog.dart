import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/exam.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class ExitConfirmationDialog extends ConsumerWidget {
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.color.surface),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.svg.close),
            12.ph,
            Text(
              'Are You Sure?',
              style: AppTextStyle(context).subTitle.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppStaticColor.redColor,
                  ),
            ),
            8.ph,
            Text(
              'Want to exit from exam lesson?',
              style: AppTextStyle(context).bodyText.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            24.ph,
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: AppOutlineButton(
                    titleColor: AppStaticColor.redColor,
                    borderRadius: 12.0,
                    title: 'Yes',
                    onTap: () {
                      context.nav.pop();
                      context.nav.pop();
                      final value = ref.refresh(examAnswerProvider.notifier);
                      debugPrint(value.toString());
                    },
                  ),
                ),
                12.pw,
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 52,
                    child: AppButton(
                      title: 'No',
                      onTap: () => context.nav.pop(),
                      width: 100.w,
                      titleColor: AppStaticColor.whiteColor,
                      buttonColor: AppStaticColor.redColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
