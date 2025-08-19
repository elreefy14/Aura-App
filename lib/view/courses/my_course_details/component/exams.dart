// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/exam/widgtes/start_exam_bottom_sheet.dart';

import '../../../../generated/l10n.dart';

class Exams extends ConsumerWidget {
  const Exams({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        ...List.generate(
            ref.read(myCourseDetailsController).courseDetails!.exams.length,
            (index) {
          final Exam exam =
              ref.read(myCourseDetailsController).courseDetails!.exams[index];
          return ExamCard(
            index: index,
            exam: exam,
          );
        }),
        20.ph
      ],
    );
  }
}

class ExamCard extends StatelessWidget {
  final Exam exam;
  final int index;
  const ExamCard({
    super.key,
    required this.exam,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ApGlobalFunctions.showBottomSheet(
        context: context,
        widget: StartExamBottomSheet(
          exam: exam,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: AppComponents.defaultBorderRadiusSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.ph,
            Row(
              children: [
                Text(
                  '${S.of(context).exam}${index + 1}',
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(fontSize: 10.sp),
                ),
                const Spacer(),
                // Text(
                //   ApGlobalFunctions.toHourMinute(
                //       time: widget.model.totalDuration, context: context),
                //   style: AppTextStyle(context).bodyTextSmall.copyWith(
                //       fontSize: 10.sp, color: colors(context).hintTextColor),
                // ),
              ],
            ),
            12.ph,
            Text(
              exam.title,
              style: AppTextStyle(context)
                  .bodyTextSmall
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            12.ph,
          ],
        ),
      ),
    );
  }
}
