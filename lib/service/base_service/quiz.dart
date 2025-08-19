import 'package:dio/dio.dart';
import 'package:ready_lms/model/quiz/quiz_submit_model.dart';

abstract class Quiz {
  Future<Response> startQuize({required int quizId});
  Future<Response> submitQuiz(
      {required QuizSubmitModel quizSubmitModel, required int quizSessionId});
}
