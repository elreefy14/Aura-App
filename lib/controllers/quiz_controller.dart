import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/quiz/quiz_submit_model.dart';
import 'package:ready_lms/model/quiz/quize_question_details_model.dart';
import 'package:ready_lms/service/quiz_service.dart';
import 'package:ready_lms/view/quiz/widgets/option_card.dart';

class QuizController extends StateNotifier<bool> {
  final Ref ref;
  QuizController(this.ref) : super(false);

  late QuizQuestionDetailsModel _quizQuestionDetailsModel;
  QuizQuestionDetailsModel get quizQuestionDetailsModel =>
      _quizQuestionDetailsModel;

  Future<bool> startQuiz({required int quizId}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(quizServiceProvider).startQuize(quizId: quizId);
      final status = response.statusCode == 201;
      if (status) {
        _quizQuestionDetailsModel =
            QuizQuestionDetailsModel.fromJson(response.data['data']);
        isSuccess = true;
      }
      state = false;

      return status;
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return isSuccess;
    } finally {
      state = false;
    }
  }

  Future<bool?> submitQuiz({
    required QuizSubmitModel quizSubmitModel,
    required int quizSessionId,
  }) async {
    state = true;
    bool? isCurrect = false;
    try {
      final response = await ref.read(quizServiceProvider).submitQuiz(
          quizSubmitModel: quizSubmitModel, quizSessionId: quizSessionId);
      final status = response.statusCode == 201;
      isCurrect = response.data['data']['previous_was_correct'];
      QuizQuestionDetailsModel quizQuestionDetailsModel =
          QuizQuestionDetailsModel.fromJson(response.data['data']);
      if (status) {
        Future.delayed(const Duration(seconds: 1), () {
          print("this is a response data: ${response.data}");
          _quizQuestionDetailsModel = quizQuestionDetailsModel;
          ref.refresh(isCurrectProvider.notifier).state;
          print("this is a response data: $_quizQuestionDetailsModel");
          state = false;
        });
      }

      return isCurrect;
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return isCurrect;
    }
  }
}

final quizControllerProvider =
    StateNotifierProvider<QuizController, bool>((ref) => QuizController(ref));
