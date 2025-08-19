import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/courses/my_course_details/component/lesson_item_card.dart';

class Lessons extends ConsumerWidget {
  const Lessons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        24.ph,
        ...List.generate(
          ref.read(myCourseDetailsController).courseDetails!.chapters.length,
          (index) => LessonCard(
            index: index,
            model: ref
                .read(myCourseDetailsController)
                .courseDetails!
                .chapters[index],
          ),
        ),
        // 20.ph
      ],
    );
  }
}

class LessonCard extends ConsumerStatefulWidget {
  const LessonCard({
    super.key,
    required this.index,
    required this.model,
  });
  final int index;
  final Chapters model;
  @override
  ConsumerState<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends ConsumerState<LessonCard> {
  final isExpand = StateProvider<bool>((ref) {
    return false;
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: AppComponents.defaultBorderRadiusSmall,
        border: Border.all(
          color: ref.watch(isExpand)
              ? colors(context).primaryColor!.withOpacity(0.4)
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          12.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Row(
              children: [
                Text(
                  '${S.of(context).cClass} ${widget.index + 1}',
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(fontSize: 10.sp),
                ),
                const Spacer(),
                Text(
                  ApGlobalFunctions.convertMinutesToHours(
                      widget.model.totalDuration, context),
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 10.sp, color: colors(context).hintTextColor),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              onExpansionChanged: (value) {
                ref.read(isExpand.notifier).state = value;
                ref
                    .read(myCourseDetailsController.notifier)
                    .setCurrentIndex(widget.index);
              },
              iconColor: colors(context).hintTextColor,
              collapsedIconColor: colors(context).hintTextColor,
              title: Padding(
                padding: EdgeInsets.only(left: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.title,
                            style: AppTextStyle(context)
                                .bodyTextSmall
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              tilePadding: EdgeInsets.only(right: 12.h),
              children: [
                ...List.generate(
                  widget.model.contents.length,
                  (index) => LessonItemCard(
                    isBottom: index == widget.model.contents.length - 1
                        ? true
                        : false,
                    model: widget.model.contents[index],
                    isActive:
                        ref.watch(myCourseDetailsController).currentPlay!.id ==
                            widget.model.contents[index].id,
                  ),
                ),
                12.ph
              ],
            ),
          ),
        ],
      ),
    );
  }
}
