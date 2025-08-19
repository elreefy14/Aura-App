// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/exam.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/exam/exam_result_model.dart';
import 'package:ready_lms/model/quiz/quize_question_details_model.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../generated/l10n.dart';

class ResultScreen extends StatelessWidget {
  final bool isQuiz;
  final Quiz? quiz;
  final QuizQuestionDetailsModel? quizQuestionDetailsModel;
  final ExamResultModel? examResultModel;
  const ResultScreen({
    super.key,
    required this.isQuiz,
    required this.quiz,
    required this.quizQuestionDetailsModel,
    required this.examResultModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.surface,
      body: _buildBodyWidget(context),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isQuiz
                ? S.of(context).resultofYourQuiz
                : S.of(context).resultofYourExam,
            style: AppTextStyle(context).bodyTextSmall,
          ),
          16.ph,
          _buildResultWidget(context),
          16.ph,
          SizedBox(
            height: 48.h,
            child: Consumer(builder: (context, ref, _) {
              return AppButton(
                height: 48.h,
                title: S.of(context).backtoClass,
                onTap: () {
                  if (!isQuiz) {
                    final data = ref.refresh(examAnswerProvider);
                  }
                  context.nav.pop();
                },
                titleColor: AppStaticColor.whiteColor,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildResultWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.00, -1.00),
          end: const Alignment(0, 20),
          colors: [
            context.color.surface,
            AppStaticColor.primaryColor.withOpacity(0.1)
          ],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: AppStaticColor.primaryColor,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          isQuiz
              ? Assets.images.pass.image()
              : examResultModel!.passMark > examResultModel!.obtainedMark
                  ? Assets.images.failed.image()
                  : Assets.images.pass.image(),
          16.ph,
          Text(
            isQuiz
                ? S.of(context).congratulations
                : examResultModel!.passMark <= examResultModel!.obtainedMark
                    ? S.of(context).congratulations
                    : S.of(context).failed,
            style: AppTextStyle(context).title.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isQuiz
                      ? AppStaticColor.primaryColor
                      : examResultModel!.passMark <=
                              examResultModel!.obtainedMark
                          ? AppStaticColor.primaryColor
                          : AppStaticColor.redColor,
                ),
          ),
          8.ph,
          Text(
            S.of(context).youhavereceivedmarkof,
            style: AppTextStyle(context)
                .subTitle
                .copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            isQuiz
                ? (quizQuestionDetailsModel!.quizSession.rightAnswerCount *
                        quiz!.markPerQuestion)
                    .toStringAsFixed(0)
                : examResultModel!.obtainedMark.toString(),
            style: AppTextStyle(context)
                .title
                .copyWith(fontSize: 36.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            isQuiz
                ? '${S.of(context).outof} ${quiz!.questionsCount * quiz!.markPerQuestion}'
                : '${S.of(context).outof} ${examResultModel!.totalMark}',
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
