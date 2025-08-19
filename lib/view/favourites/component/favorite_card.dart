import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/components/course_shorts_info.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/courses/new_course/course_new_screen.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard(
      {super.key,
      required this.onTap,
      required this.canEnroll,
      required this.model});
  final bool canEnroll;
  final VoidCallback onTap;
  final CourseListModel model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!canEnroll) {
          context.nav.pushNamed(Routes.myCourseDetails, arguments: model.id);
        } else {
          context.nav
              .pushNamed(Routes.courseNew, arguments: {'courseId': model.id});
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: AppComponents.defaultBorderRadiusSmall,
            color: context.color.onSecondary),
        padding: EdgeInsets.all(
          16.h,
        ),
        margin: EdgeInsets.only(bottom: 12.h, left: 16.h, right: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16.h,
                  height: 16.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.h),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/spinner.gif',
                      image: model.instructor.profilePicture,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                6.pw,
                Text(
                  model.instructor.name,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      color: context.color.inverseSurface, fontSize: 12.sp),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: SvgPicture.asset(
                    'assets/svg/ic_heart.svg',
                    width: 20.h,
                    height: 20.h,
                  ),
                )
              ],
            ),
            12.ph,
            Text(
              model.title,
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
                totalRating: '(${model.reviewCount})'),
            12.ph,
            if (canEnroll)
              Row(
                children: [
                  if (model.isFree == 1)
                    // If the course is free, display "Free" and show regular price with strike-through
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).free, // Displays "Free" label
                          style: AppTextStyle(context).subTitle,
                        ),
                        4.ph, // Padding between Free and regular price
                        model.price != null || model.isFree == 1
                            ? model.regularPrice != null
                                ? Text(
                                    '${AppConstants.currencySymbol}${model.regularPrice}', // Show regular price
                                    style: AppTextStyle(context)
                                        .buttonText
                                        .copyWith(
                                          color: colors(context).hintTextColor,
                                          decoration: TextDecoration
                                              .lineThrough, // Strike-through effect
                                          decorationColor:
                                              colors(context).hintTextColor,
                                        ),
                                  )
                                : const SizedBox()
                            : const SizedBox(),
                      ],
                    )
                  else ...[
                    // If the course is not free, display the current price and regular price
                    Text(
                      '${AppConstants.currencySymbol}${model.price ?? model.regularPrice}',
                      style: AppTextStyle(context).subTitle,
                    ),
                    4.pw,
                    model.price != null
                        ? Text(
                            '${AppConstants.currencySymbol}${model.regularPrice}',
                            style: AppTextStyle(context).buttonText.copyWith(
                                  color: colors(context).hintTextColor,
                                  decoration: TextDecoration
                                      .lineThrough, // Strike-through effect
                                  decorationColor:
                                      colors(context).hintTextColor,
                                ),
                          )
                        : const SizedBox()
                  ],

                  // Text(
                  //   '${AppConstants.currencySymbol}${model.price}',
                  //   style: AppTextStyle(context).subTitle,
                  // ),
                  // 4.pw,
                  // Text(
                  //   '${AppConstants.currencySymbol}${model.regularPrice}',
                  //   style: AppTextStyle(context).buttonText.copyWith(
                  //         color: colors(context).hintTextColor,
                  //         decoration: TextDecoration.lineThrough,
                  //         decorationColor: colors(context).hintTextColor,
                  //       ),
                  // ),

                  const Spacer(),
                  Consumer(builder: (context, ref, _) {
                    return AppButton(
                      title: S.of(context).enrolNow,
                      titleColor: context.color.surface,
                      onTap: () {
                        if (model.isFree == 1) {
                          ref
                              .read(freeCourseEnrollController.notifier)
                              .freeCourseEnroll(courseId: model.id)
                              .then((response) {
                            if (response.isSuccess) {
                              courseEnrollSuccessDialog(
                                context: context,
                                ref: ref,
                              );
                            }
                          });
                        } else {
                          context.nav.pushNamed(Routes.checkOutScreen,
                              arguments: model.id);
                        }
                      },
                    );
                  })
                ],
              ),
            if (!canEnroll)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).enrolled,
                    style: AppTextStyle(context)
                        .bodyText
                        .copyWith(color: colors(context).primaryColor),
                  ),
                  AppOutlineButton(
                    title: S.of(context).viewCourse,
                    borderRadius: 8.r,
                    fontSize: 12.sp,
                    textPaddingHorizontal: 16.w,
                    textPaddingVertical: 10.w,
                    fontWeight: FontWeight.w400,
                    width: null,
                    onTap: () {
                      context.nav.pushNamed(Routes.myCourseDetails,
                          arguments: model.id);
                    },
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
