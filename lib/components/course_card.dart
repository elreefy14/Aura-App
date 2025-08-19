import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/course_shorts_info.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../config/app_constants.dart';
import '../config/theme.dart';
import '../utils/global_function.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.onTap,
    this.height = 120,
    this.width = 312,
    this.marginRight = 0,
    this.marginBottom = 0,
    required this.model,
    this.maxLineOfTitle = 2,
  });

  final double height, width, marginRight, marginBottom;
  final VoidCallback onTap;
  final CourseListModel model;
  final int? maxLineOfTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.h,
      margin: EdgeInsets.only(right: marginRight.h, bottom: marginBottom.h),
      decoration: BoxDecoration(
          borderRadius: AppComponents.defaultBorderRadiusSmall,
          color: context.color.surface),
      child: ClipRRect(
        borderRadius: AppComponents.defaultBorderRadiusSmall,
        child: Column(
          children: [
            FadeInImage.assetNetwork(
              placeholderFit: BoxFit.contain,
              placeholder: 'assets/images/spinner.gif',
              image: model.thumbnail,
              width: width.h,
              height: height.h,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: context.color.primary);
              },
            ),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.category,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontSize: 10.sp, color: context.color.primary),
                  ),
                  4.ph,
                  Text(
                    model.title,
                    maxLines: maxLineOfTitle,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(),
                  ),
                  8.ph,
                  CourseShortsInfo(
                    totalTime: ApGlobalFunctions.convertMinutesToHours(
                        model.totalDuration, context),
                    totalEnrolled: '${model.studentCount}',
                    rating: double.tryParse('${model.averageRating}')!
                        .toStringAsFixed(1)
                        .toString(),
                    totalRating: '(${model.reviewCount})',
                  ),
                  12.ph,
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.isFree == 1
                                ? S.of(context).free
                                : model.price != null
                                    ? "${AppConstants.currencySymbol}${model.price}"
                                    : "${AppConstants.currencySymbol}${model.price ?? model.regularPrice}",
                            style: AppTextStyle(context).subTitle,
                          ),
                          4.pw,
                          model.price != null || model.isFree == 1
                              ? model.regularPrice != null
                                  ? Text(
                                      '${AppConstants.currencySymbol}${model.regularPrice}',
                                      style: AppTextStyle(context)
                                          .buttonText
                                          .copyWith(
                                            color:
                                                colors(context).hintTextColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor:
                                                colors(context).hintTextColor,
                                          ),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                        ],
                      ),
                      const Spacer(),
                      AppButton(
                        title: S.of(context).viewDetails,
                        titleColor: context.color.surface,
                        onTap: onTap,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
