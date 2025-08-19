import 'package:ready_lms/components/rate_now_widget.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ReviewWidgets extends ConsumerStatefulWidget {
  const ReviewWidgets({super.key});

  @override
  ConsumerState<ReviewWidgets> createState() => _ReviewWidgetsState();
}

class _ReviewWidgetsState extends ConsumerState<ReviewWidgets> {
  @override
  Widget build(BuildContext context) {
    var model = ref.watch(myCourseDetailsController).courseDetails;
    return model != null
        ? Container(
            color: context.color.surface,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (model.course.canReview && !model.course.isReviewed)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
                    child: RateNowCard(
                      courseId: model.course.id,
                      onReviewed: (data) {
                        ref
                            .read(myCourseDetailsController.notifier)
                            .updateReview(model.course.id, data);
                        setState(() {});
                      },
                    ),
                  ),
                if (model.course.isReviewed)
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).youHaveAlready,
                                  style: AppTextStyle(context)
                                      .bodyTextSmall
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: context.color.primary,
                                          fontSize: 10.sp),
                                ),
                                Text(
                                  S.of(context).ratedThisCourse,
                                  style: AppTextStyle(context)
                                      .bodyTextSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                )
                              ],
                            )),
                            SvgPicture.asset(
                              'assets/svg/ic_star.svg',
                              height: 18.h,
                              width: 18.h,
                            ),
                            4.pw,
                            Text(
                              "${model.course.submittedReview?.rating.toInt() ?? '0'}/5",
                              style: AppTextStyle(context)
                                  .bodyTextSmall
                                  .copyWith(
                                      color: context.color.inverseSurface,
                                      fontWeight: FontWeight.w600),
                            ),
                            4.pw,
                          ],
                        ),
                        12.ph,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.h),
                          decoration: BoxDecoration(
                              color: colors(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Text(
                            model.course.submittedReview?.comment ??
                                "Demo Comment",
                            style: AppTextStyle(context).bodyTextSmall.copyWith(
                                fontSize: 12.sp, fontWeight: FontWeight.w200),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          )
        : Container();
  }
}
