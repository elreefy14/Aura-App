import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/exam.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/model/exam/exam_question.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class QuestionCard extends ConsumerStatefulWidget {
  final int index;
  final Questions question;
  const QuestionCard({super.key, required this.index, required this.question});

  @override
  ConsumerState<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.color.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.index + 1}. ",
                style: AppTextStyle(context).bodyText.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Expanded(
                child: Text(
                  widget.question.questionText,
                  style: AppTextStyle(context).bodyText.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          8.ph,
          ...List.generate(
            widget.question.options.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                  bottom: index != widget.question.options.length ? 8.h : 0),
              child: _buildOptionCard(
                  widget.question.options[index], index, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(Options option, int index, BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Material(
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: () {
            ref.read(examAnswerProvider.notifier).toggleAnswer(
                question: widget.question, selectedAnswer: option.text);
            setState(() {});
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: ref
                          .watch(examAnswerProvider.notifier)
                          .isOptionSelected(
                              questionId: widget.question.id,
                              option: option.text,
                              type: widget.question.questionType)
                      ? context.color.primary
                      : colors(context).scaffoldBackgroundColor!,
                ),
                color: context.color.surface),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  ref.watch(examAnswerProvider.notifier).isOptionSelected(
                          questionId: widget.question.id,
                          option: option.text,
                          type: widget.question.questionType)
                      ? Assets.svg.radioActive
                      : Assets.svg.radioInactive,
                  width: 20,
                  color: ref
                          .watch(examAnswerProvider.notifier)
                          .isOptionSelected(
                              questionId: widget.question.id,
                              option: option.text,
                              type: widget.question.questionType)
                      ? colors(context).primaryColor
                      : colors(context).scaffoldBackgroundColor,
                ),
                6.pw,
                Expanded(
                  child: Text(
                    option.text,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
