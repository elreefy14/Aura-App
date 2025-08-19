import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/exam_controller.dart';
import 'package:ready_lms/model/exam/answer.dart';
import 'package:ready_lms/model/exam/exam_question.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/exam/widgtes/submit_button.dart';

import '../../../generated/l10n.dart';

class AnswerReviewBottomSheet extends ConsumerStatefulWidget {
  final ExamQustion examQustion;
  final List<Answer> answers;
  final String leftTime;
  final bool isTimeEnd;

  const AnswerReviewBottomSheet({
    super.key,
    required this.examQustion,
    required this.answers,
    required this.leftTime,
    this.isTimeEnd = false,
  });

  @override
  ConsumerState<AnswerReviewBottomSheet> createState() =>
      _AnswerReviewBottomSheetState();

  static const String reviewText =
      "Before submitting, review your answersto make any final changes and ensure you've answered every question to the best of your ability.";
}

class _AnswerReviewBottomSheetState
    extends ConsumerState<AnswerReviewBottomSheet> {
  final submitButtonKey = GlobalKey<SubmitButtonState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      if (widget.isTimeEnd) {
        _submitAnswer();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp).copyWith(top: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              S.of(context).pleaseReiewYourAnswers,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).subTitle.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.44.sp),
            ),
          ),
          8.ph,
          Text(
            S.of(context).custom,
            textAlign: TextAlign.center,
            style: AppTextStyle(context).bodyText.copyWith(
                letterSpacing: 0.32.sp, color: AppStaticColor.blueColor),
          ),
          16.ph,
          _buildSummeryWidget(context),
          16.ph,
          Text(
            S.of(context).onceconfidenttapandoldSubmitbuttonbellow,
            textAlign: TextAlign.center,
            style: AppTextStyle(context).bodyTextSmall,
          ),
          16.ph,
          ref.watch(examControllerProvider)
              ? const CircularProgressIndicator()
              : SubmitButton(
                  isComplete: (p0) => _submitAnswer(),
                  color: colors(context).primaryColor!,
                )
        ],
      ),
    );
  }

  Container _buildSummeryWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.dm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: colors(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          _buidRowWidget(
            context: context,
            title: S.of(context).answeredQuestions,
            value: widget.answers.length.toString(),
          ),
          12.ph,
          _buidRowWidget(
            context: context,
            title: S.of(context).Missed,
            value: (widget.examQustion.questions.length - widget.answers.length)
                .toString(),
          ),
          12.ph,
          _buidRowWidget(
              context: context,
              title: S.of(context).timeLeft,
              value: widget.leftTime),
        ],
      ),
    );
  }

  Row _buidRowWidget(
      {required BuildContext context,
      required String title,
      required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle(context).bodyTextSmall,
        ),
        Text(
          value,
          style: AppTextStyle(context)
              .bodyTextSmall
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  void _submitAnswer() {
    ref
        .read(examControllerProvider.notifier)
        .submitExam(
            answers: widget.answers, examId: widget.examQustion.examSession.id)
        .then((data) {
      if (data != null) {
        context.nav.pop();
        context.nav.popAndPushNamed(Routes.resultScreen, arguments: {
          'isQuize': false,
          'quiz': null,
          'quizDetails': null,
          'examResult': data,
        });
      }
    });
  }

  // convert second to min
  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;

    if (minutes == 0) {
      return '$remainingSeconds seconds';
    } else if (remainingSeconds == 0) {
      return '$minutes minutes';
    } else {
      return '$minutes minutes ${remainingSeconds.toString().padLeft(2, '0')} seconds';
    }
  }
}
