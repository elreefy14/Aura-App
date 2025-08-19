// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/exit_confirmation_dialog.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/exam.dart';
import 'package:ready_lms/controllers/exam_controller.dart';
import 'package:ready_lms/model/exam/exam_question.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/exam/widgtes/answer_review_bottom_sheet.dart';
import 'package:ready_lms/view/exam/widgtes/bool_question_card.dart';
import 'package:ready_lms/view/exam/widgtes/exam_timer_widget.dart';
import 'package:ready_lms/view/exam/widgtes/question_card.dart';
import 'package:ready_lms/view/quiz/widgets/option_card.dart';

import '../../generated/l10n.dart';
import '../../model/course_detail.dart';

class ExamScreen extends ConsumerStatefulWidget {
  final Exam exam;
  const ExamScreen({
    super.key,
    required this.exam,
  });

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  final examTimerWidgetKey = GlobalKey<ExamTimerWidgetState>();
  String leftTime = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const ExitConfirmationDialog(),
            ),
            icon: const Icon(Icons.close),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: ExamTimerWidget(
              key: examTimerWidgetKey,
              startTimer: (p0) {
                print("start");
              },
              pauseTimer: (p0) {
                print("pause");
              },
              onTimerChanged: (p0) {
                leftTime = p0;
              },
              onTimerEnded: (p0) {
                return ApGlobalFunctions.showBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  widget: AnswerReviewBottomSheet(
                    examQustion:
                        ref.read(examControllerProvider.notifier).examQustion,
                    answers: ref.read(examAnswerProvider),
                    leftTime: '${widget.exam.duration} minutes',
                    isTimeEnd: true,
                  ),
                );
              },
              duration: widget.exam.duration,
            ),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeaderWidget(context),
          _buildQuestionListWidget(context)
        ],
      ),
    );
  }

  _buildHeaderWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.color.surface,
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 16.h),
      child: Container(
        width: double.infinity,
        height: 84.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.00, -1.00),
            end: const Alignment(0, 20),
            colors: [
              context.color.surface,
              colors(context).primaryColor!,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: const Border(
            bottom: BorderSide(width: 4, color: Color(0xFF8500FA)),
          ),
        ),
        child: Text(
          widget.exam.title,
          style: AppTextStyle(context).title.copyWith(
              fontSize: 24.sp,
              color: colors(context).primaryColor,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _buildQuestionListWidget(BuildContext context) {
    final List<Questions> questions =
        ref.read(examControllerProvider.notifier).examQustion.questions;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemBuilder: ((context, index) {
        if (index == questions.length) {
          return AppButton(
            title: S.of(context).submit,
            titleColor: AppStaticColor.whiteColor,
            onTap: () {
              examTimerWidgetKey.currentState?.getCurrentTime();
              ApGlobalFunctions.showBottomSheet(
                enableDrag: false,
                context: context,
                widget: AnswerReviewBottomSheet(
                  examQustion:
                      ref.read(examControllerProvider.notifier).examQustion,
                  answers: ref.read(examAnswerProvider),
                  leftTime: leftTime,
                ),
              );
            },
          );
        }
        return questions[index].questionType == QuestionType.single.name ||
                questions[index].questionType == QuestionType.multiple.name
            ? QuestionCard(
                index: index,
                question: questions[index],
              )
            : BoolQuestionCard(
                index: index,
                question: questions[index],
              );
      }),
      itemCount: questions.length + 1,
    );
  }
}
