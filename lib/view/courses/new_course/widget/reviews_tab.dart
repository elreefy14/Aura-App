import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/star_rating.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key, required this.model});
  final CourseDetailModel model;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: model.reviews.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50.h), // For spacing
                child: const Text(
                  'No Reviews!',
                ),
              ),
            )
          : Column(
              children: [
                24.ph,
                ...List.generate(
                    model.reviews.length,
                    (index) => ReviewCard(
                          model: model.reviews[index],
                        )),
                20.ph
              ],
            ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.model});
  final Reviews model;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: AppComponents.defaultBorderRadiusSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
                color:
                    colors(context).scaffoldBackgroundColor!.withOpacity(.4)),
            child: Row(
              children: [
                Container(
                  width: 36.h,
                  height: 36.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors(context).hintTextColor!.withOpacity(.7)),
                  child: Center(
                    child: Text(
                      model.user.name.substring(0, 2),
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.color.surface),
                    ),
                  ),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.user.name,
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Row(
                        children: [
                          StarRating(
                            rating: model.rating.toInt(),
                            color: AppStaticColor.orangeColor,
                          ),
                          const Spacer(),
                          Text(
                            ApGlobalFunctions.toDateFormateMinHouDayWeekDateAgo(
                                model.createdAt, context),
                            style: AppTextStyle(context).bodyTextSmall.copyWith(
                                fontSize: 10.sp,
                                color: colors(context).hintTextColor),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.h),
            child: Text(
              model.comment,
              style: AppTextStyle(context).bodyTextSmall.copyWith(),
            ),
          )
        ],
      ),
    );
  }
}
