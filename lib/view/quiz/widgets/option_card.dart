import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/quiz_controller.dart';
import 'package:ready_lms/model/quiz/quiz_submit_model.dart';
import 'package:ready_lms/view/quiz/widgets/timer_progress_bar.dart';

import '../../../model/quiz/quize_question_details_model.dart';

class QuizOptionCard extends ConsumerStatefulWidget {
  final Options option;
  final String questionType;
  final int questionId;
  final int quizSessionId;
  final Function(bool) onDone;

  const QuizOptionCard({
    super.key,
    required this.option,
    required this.questionType,
    required this.questionId,
    required this.quizSessionId,
    required this.onDone,
  });

  @override
  ConsumerState<QuizOptionCard> createState() => _QuizOptionCardState();
}

class _QuizOptionCardState extends ConsumerState<QuizOptionCard> {
  final GlobalKey<TimerProgressBarState> _timerKey =
      GlobalKey<TimerProgressBarState>();
  @override
  Widget build(BuildContext context) {
    final selectedAns = ref.watch(selectedAnsProvider);
    final isSelected = selectedAns.contains(widget.option.text);
    final isCurrect = ref.watch(isCurrectProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _handleTap(isSelected),
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: _getDecoration(context, isSelected, isCurrect),
        child: Text(
          widget.option.text,
          style: AppTextStyle(context)
              .bodyTextSmall
              .copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(
      BuildContext context, bool isSelected, bool? isCurrect) {
    if (widget.questionType == QuestionType.multiple.name) {
      if (isSelected) {
        return _selectedDecoration(context);
      }

      return _unselectedDecoration(context);
    } else {
      if (isSelected) {
        return isCurrect == true
            ? _correctDecoration()
            : isCurrect == false
                ? _wrongAnsDecoration()
                : _selectedDecoration(context);
      }
    }

    return _unselectedDecoration(context);
  }

  BoxDecoration _selectedDecoration(BuildContext context) {
    return BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          left: BorderSide(color: AppStaticColor.primaryColor, width: 1),
          right: BorderSide(color: AppStaticColor.primaryColor, width: 1),
          top: BorderSide(color: AppStaticColor.primaryColor, width: 1),
          bottom: BorderSide(width: 3, color: AppStaticColor.primaryColor),
        ));
  }

  BoxDecoration _unselectedDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(10),
      border:
          const Border(bottom: BorderSide(color: Color(0xFFDADADA), width: 3)),
    );
  }

  BoxDecoration _correctDecoration() {
    return BoxDecoration(
      color: const Color(0x3F11CE00),
      borderRadius: BorderRadius.circular(10),
      border: const Border(
        bottom: BorderSide(width: 3, color: Color(0xFF10CE00)),
      ),
    );
  }

  BoxDecoration _wrongAnsDecoration() {
    return BoxDecoration(
      color: const Color(0x3FFF0000),
      borderRadius: BorderRadius.circular(10),
      border: const Border(
        bottom: BorderSide(width: 3, color: AppStaticColor.redColor),
      ),
    );
  }

  void _handleTap(bool isSelected) {
    ref.read(selectedAnsProvider.notifier).update((state) {
      final updatedList = List<String>.from(state);

      if (widget.questionType == QuestionType.single.name ||
          widget.questionType == QuestionType.binary.name) {
        updatedList
          ..clear()
          ..add(widget.option.text);
      } else {
        isSelected
            ? updatedList.remove(widget.option.text)
            : updatedList.add(widget.option.text);
      }

      return updatedList;
    });

    if (widget.questionType == QuestionType.binary.name ||
        widget.questionType == QuestionType.single.name) {
      final quizSubmitModel = QuizSubmitModel(
        questionId: widget.questionId,
        choice: ref.read(selectedAnsProvider).first,
        choices: [],
        skip: false,
      );

      ref
          .read(quizControllerProvider.notifier)
          .submitQuiz(
              quizSubmitModel: quizSubmitModel,
              quizSessionId: widget.quizSessionId)
          .then((isCorrect) {
        Future.delayed(const Duration(seconds: 1), () {
          ref.read(actionProvider.notifier).state = ActionType.submit;
          widget.onDone(true);
        });

        ref.read(isCurrectProvider.notifier).state = isCorrect;
      });
    }
  }
}

final selectedAnsProvider = StateProvider<List<String>>((ref) => []);
final isCurrectProvider = StateProvider<bool?>((ref) => null);
final actionProvider = StateProvider<ActionType?>((ref) => null);

enum QuestionType { multiple, single, binary }

enum ActionType { submit, skip, next }
