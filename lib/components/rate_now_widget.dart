import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/components/rate_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateNowCard extends StatelessWidget {
  const RateNowCard(
      {super.key,
      this.backgroundColor,
      this.textColor,
      required this.courseId,
      required this.onReviewed});
  final Color? backgroundColor, textColor;
  final int courseId;
  final ValueChanged<SubmittedReview> onReviewed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor ?? colors(context).primaryColor,
          borderRadius: BorderRadius.circular(8.r)),
      padding: EdgeInsets.all(10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              S.of(context).notRating,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: textColor ?? context.color.surface),
            ),
          ),
          GestureDetector(
            onTap: () {
              ApGlobalFunctions.showBottomSheet(
                  context: context,
                  widget: RateBottomWidget(
                    id: courseId,
                    onReviewed: onReviewed,
                  ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.5.w, vertical: 2.h),
              decoration: BoxDecoration(
                  color: AppStaticColor.yellowColor,
                  borderRadius: BorderRadius.circular(24.r)),
              child: Text(
                S.of(context).rateNow,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
