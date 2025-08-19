import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/quiz_controller.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/quiz/quiz_submit_model.dart';
import 'package:ready_lms/model/quiz/quize_question_details_model.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/quiz/widgets/option_card.dart';
import 'package:ready_lms/view/quiz/widgets/timer_progress_bar.dart';

import '../../generated/l10n.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final Quiz quiz;
  const QuizScreen({
    super.key,
    required this.quiz,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  final GlobalKey<TimerProgressBarState> _timerKey =
      GlobalKey<TimerProgressBarState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      ref.invalidate(selectedAnsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    _navigationListener();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBody(context),
          if (ref.watch(quizControllerProvider))
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildHeaderWidget(context),
        32.ph,
        _buildQuestionCard(context),
      ],
    );
  }

  Widget _buildHeaderWidget(BuildContext context) {
    final questionDetailsModel =
        ref.watch(quizControllerProvider.notifier).quizQuestionDetailsModel;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h)
          .copyWith(top: 26.h, left: 14.w),
      color: context.color.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.nav.pop(),
                icon: Icon(
                  Icons.close,
                  size: 24.sp,
                ),
              ),
              Text(
                '${questionDetailsModel.quizSession.seenQuestionIds.length}/${widget.quiz.questionsCount}',
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  ref.read(actionProvider) == ActionType.skip;
                  Future.delayed(const Duration(milliseconds: 500))
                      .then((v) async {
                    _handleTapSkip(questionDetailsModel);
                  });
                },
                child: Text(
                  S.of(context).skip,
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          8.ph,
          Text(
            widget.quiz.title,
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w500),
          ),
          8.ph,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildResultWidget(
                  context: context,
                  icon: Assets.svg.correct,
                  result: questionDetailsModel.quizSession.rightAnswerCount,
                ),
                22.pw,
                _buildResultWidget(
                  context: context,
                  icon: Assets.svg.wrong,
                  result: questionDetailsModel.quizSession.wrongAnswerCount,
                ),
                22.pw,
                _buildResultWidget(
                  context: context,
                  icon: Assets.svg.skip,
                  result: questionDetailsModel.quizSession.skippedAnswerCount,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultWidget({
    required BuildContext context,
    required String icon,
    required int result,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 16.w,
          height: 16.h,
        ),
        8.pw,
        Text(
          result.toString(),
          style: AppTextStyle(context).bodyText,
        ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    final QuizQuestionDetailsModel quizDetailsModel =
        ref.watch(quizControllerProvider.notifier).quizQuestionDetailsModel;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.color.surface,
      ),
      child: Column(
        children: [
          TimerProgressBar(
            key: _timerKey,
            duration: widget.quiz.durationPerQuestion,
            onEnd: () {
              if (ref.read(actionProvider) == ActionType.submit ||
                  ref.read(actionProvider) == ActionType.skip) {
                ref.refresh(actionProvider.notifier).state;
              } else {
                _handleTapNext(quizDetailsModel);
              }
            },
            onReset: () {},
          ),
          16.ph,
          Text(
            quizDetailsModel.question != null
                ? quizDetailsModel.question!.questionText
                : '',
            style: AppTextStyle(context)
                .subTitle
                .copyWith(fontWeight: FontWeight.w500),
          ),
          18.ph,
          quizDetailsModel.question != null
              ? _buildOptionsWidget()
              : const SizedBox.shrink(),
          18.ph,
          quizDetailsModel.question != null
              ? quizDetailsModel.question!.questionType ==
                      QuestionType.multiple.name
                  ? _buildSubmitWidget(context)
                  : const SizedBox()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildOptionsWidget() {
    return AbsorbPointer(
      absorbing: ref.watch(quizControllerProvider),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: ref
            .watch(quizControllerProvider.notifier)
            .quizQuestionDetailsModel
            .question!
            .options
            .length,
        itemBuilder: (context, index) {
          final options = ref
              .watch(quizControllerProvider.notifier)
              .quizQuestionDetailsModel
              .question!
              .options[index];
          return QuizOptionCard(
            questionId: ref
                .watch(quizControllerProvider.notifier)
                .quizQuestionDetailsModel
                .question!
                .id,
            quizSessionId: ref
                .watch(quizControllerProvider.notifier)
                .quizQuestionDetailsModel
                .quizSession
                .id,
            option: options,
            questionType: ref
                .watch(quizControllerProvider.notifier)
                .quizQuestionDetailsModel
                .question!
                .questionType,
            onDone: (p0) {
              _timerKey.currentState?.resetTimer();
            },
          );
        },
      ),
    );
  }

  Widget _buildSubmitWidget(BuildContext context) {
    return AppButton(
      title: S.of(context).submit,
      onTap: () => _handleTap(
        ref.watch(quizControllerProvider.notifier).quizQuestionDetailsModel,
      ),
      buttonColor: ref.watch(isCurrectProvider) == null
          ? AppStaticColor.primaryColor
          : ref.watch(isCurrectProvider) == true
              ? AppStaticColor.greenColor
              : AppStaticColor.redColor,
      titleColor: AppStaticColor.whiteColor,
    );
  }

  void _handleTap(QuizQuestionDetailsModel questionDetailsModel) {
    final quizSubmitModel = QuizSubmitModel(
      questionId: questionDetailsModel.question!.id,
      choice: null,
      choices: ref.read(selectedAnsProvider),
      skip: false,
    );
    if (ref.read(selectedAnsProvider).isNotEmpty) {
      ref
          .read(quizControllerProvider.notifier)
          .submitQuiz(
              quizSubmitModel: quizSubmitModel,
              quizSessionId: questionDetailsModel.quizSession.id)
          .then((isCorrect) {
        ref.read(actionProvider.notifier).state = ActionType.submit;
        _timerKey.currentState?.resetTimer();
        ref.read(isCurrectProvider.notifier).state = isCorrect;
      });
    }
  }

  _handleTapSkip(QuizQuestionDetailsModel questionDetailsModel) {
    ref.read(actionProvider.notifier).state = ActionType.skip;
    final QuizSubmitModel quizSubmitModel = QuizSubmitModel(
      questionId: questionDetailsModel.question!.id,
      choice: null,
      choices: [],
      skip: true,
    );
    ref
        .read(quizControllerProvider.notifier)
        .submitQuiz(
            quizSessionId: questionDetailsModel.quizSession.id,
            quizSubmitModel: quizSubmitModel)
        .then((value) => _timerKey.currentState?.resetTimer());
  }

  _handleTapNext(QuizQuestionDetailsModel questionDetailsModel) {
    final QuizSubmitModel quizSubmitModel = QuizSubmitModel(
      questionId: questionDetailsModel.question!.id,
      choice: null,
      choices: [],
      skip: true,
    );
    ref
        .read(quizControllerProvider.notifier)
        .submitQuiz(
            quizSessionId: questionDetailsModel.quizSession.id,
            quizSubmitModel: quizSubmitModel)
        .then((value) => _timerKey.currentState?.resetTimer());
  }

  void _navigationListener() {
    ref.listen(quizControllerProvider, (previous, next) {
      if (ref
              .read(quizControllerProvider.notifier)
              .quizQuestionDetailsModel
              .question ==
          null) {
        Future.delayed(const Duration(milliseconds: 200), () {
          context.nav.popAndPushNamed(Routes.resultScreen, arguments: {
            'isQuize': true,
            'quiz': widget.quiz,
            'quizDetails': ref
                .read(quizControllerProvider.notifier)
                .quizQuestionDetailsModel,
            'examResult': null,
          });
        });
      }
    });
  }
}
