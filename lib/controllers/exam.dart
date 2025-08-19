import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/exam/answer.dart';
import 'package:ready_lms/model/exam/exam_question.dart';
import 'package:ready_lms/view/quiz/widgets/option_card.dart';

class ExamAnswerNotifier extends StateNotifier<List<Answer>> {
  final Ref ref;

  ExamAnswerNotifier(this.ref) : super([]);

  // Toggle answer selection
  void toggleAnswer(
      {required Questions question, required String selectedAnswer}) {
    Answer? existingAnswer = findAnswer(questionId: question.id);

    if (existingAnswer == null) {
      _addNewAnswer(question: question, selectedAnswer: selectedAnswer);
    } else {
      _updateExistingAnswer(
          answer: existingAnswer,
          question: question,
          selectedAnswer: selectedAnswer);
    }
  }

  // Add a new answer
  void _addNewAnswer(
      {required Questions question, required String selectedAnswer}) {
    final Answer newAnswer = (question.questionType ==
            QuestionType.multiple.name)
        ? Answer(
            questionId: question.id, choices: [selectedAnswer], choice: null)
        : Answer(questionId: question.id, choice: selectedAnswer, choices: []);

    addAnswer(answer: newAnswer);
  }

  // Update an existing answer
  void _updateExistingAnswer({
    required Answer answer,
    required Questions question,
    required String selectedAnswer,
  }) {
    if (question.questionType == QuestionType.multiple.name) {
      if (answer.choices.contains(selectedAnswer)) {
        answer.choices.remove(selectedAnswer);
      } else {
        answer.choices.add(selectedAnswer);
      }
    } else {
      answer.choice = selectedAnswer;
    }
  }

  // Add or replace an answer in the state
  void addAnswer({required Answer answer}) {
    state = [...state, answer];
  }

  // Find an answer by question ID
  Answer? findAnswer({required int questionId}) {
    return state.firstWhereOrNull((answer) => answer.questionId == questionId);
  }

  // Check if an option is selected
  bool isOptionSelected(
      {required int questionId, required String option, required String type}) {
    if (type == QuestionType.multiple.name) {
      return state.any((answer) =>
          answer.questionId == questionId && answer.choices.contains(option));
    }
    return state.any(
        (answer) => answer.questionId == questionId && answer.choice == option);
  }
}

final examAnswerProvider =
    StateNotifierProvider<ExamAnswerNotifier, List<Answer>>(
        (ref) => ExamAnswerNotifier(ref));
