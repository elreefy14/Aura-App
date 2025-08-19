import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/exam.dart';
import 'package:ready_lms/model/exam/exam_question.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class BoolQuestionCard extends ConsumerStatefulWidget {
  final Questions question;
  final int index;
  const BoolQuestionCard(
      {super.key, required this.question, required this.index});

  @override
  ConsumerState<BoolQuestionCard> createState() => _BoolQuestionCardState();
}

class _BoolQuestionCardState extends ConsumerState<BoolQuestionCard> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Widget>.generate(
              widget.question.options.length,
              (index) => Flexible(
                flex: 1,
                child: _buildOptionCard(
                  option: widget.question.options[index],
                  index: index,
                  context: context,
                  ref: ref,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required Options option,
    required int index,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: () {
          ref.read(examAnswerProvider.notifier).toggleAnswer(
              question: widget.question, selectedAnswer: option.text);
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.only(
              right: index == 0 ? 8.w : 0,
              left: index == widget.question.options.length - 1 ? 8.w : 0),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: ref.watch(examAnswerProvider.notifier).isOptionSelected(
                      questionId: widget.question.id,
                      option: option.text,
                      type: widget.question.questionType)
                  ? colors(context).primaryColor!
                  : colors(context).scaffoldBackgroundColor!,
            ),
          ),
          child: Center(
            child: Text(
              option.text,
              style: AppTextStyle(context)
                  .bodyTextSmall
                  .copyWith(fontWeight: FontWeight.w400),
            ),
          ),
        ),
      );
    });
  }
}
