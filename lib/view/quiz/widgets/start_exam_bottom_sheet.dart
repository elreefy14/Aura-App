// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/quiz_controller.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../../generated/l10n.dart';

class StartQuizBottomSheet extends ConsumerWidget {
  final Quiz quiz;
  const StartQuizBottomSheet({
    super.key,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h).copyWith(
            bottom: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.exam.image(),
              16.ph,
              Text(
                S.of(context).startYourQuiz,
                style: AppTextStyle(context).subTitle.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              12.ph,
              Text(
                quiz.title,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(color: AppStaticColor.blueColor),
              ),
              16.ph,
              _buildSummeryWidget(context),
              20.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: _instructionsWidget(context),
              ),
              20.ph,
              ref.watch(quizControllerProvider)
                  ? const CircularProgressIndicator()
                  : AppButton(
                      title: S.of(context).startQuize,
                      onTap: () => _startQuiz(ref, context),
                      titleColor: AppStaticColor.whiteColor,
                    )
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => context.nav.pop(),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: AppStaticColor.grayColor.withOpacity(0.8),
              child: const Icon(
                Icons.close,
                size: 18,
                color: AppStaticColor.whiteColor,
              ),
            ),
          ),
        ),
      ],
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
              title: S.of(context).numberofQuestions,
              value: quiz.questionsCount.toString()),
          12.ph,
          _buidRowWidget(
              context: context,
              title: S.of(context).perQuestion,
              value: quiz.markPerQuestion.toString()),
          12.ph,
          _buidRowWidget(
              context: context,
              title: S.of(context).totalMark,
              value: (quiz.questionsCount * quiz.markPerQuestion).toString()),
        ],
      ),
    );
  }

  Column _instructionsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.of(context).instructions,
          style: AppTextStyle(context).bodyTextSmall.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        6.ph,
        Row(
          children: [
            CircleAvatar(
              radius: 2,
              backgroundColor: colors(context).primaryColor,
            ),
            6.pw,
            Text(
              S.of(context).ensureyouhavestableinternetconnection,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: colors(context).primaryColor,
                  ),
            ),
          ],
        ),
        6.ph,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 2,
              backgroundColor: colors(context).primaryColor,
            ),
            6.pw,
            Expanded(
              child: Text(
                S
                    .of(context)
                    .carefullyreadeachquestionbeforesubmitingyouranswer,
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: colors(context).primaryColor,
                    ),
              ),
            ),
          ],
        ),
      ],
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

  void _startQuiz(WidgetRef ref, BuildContext context) {
    ref
        .read(quizControllerProvider.notifier)
        .startQuiz(quizId: quiz.id)
        .then((value) {
      context.nav.popAndPushNamed(Routes.quizScreen, arguments: quiz);
    });
  }
}
