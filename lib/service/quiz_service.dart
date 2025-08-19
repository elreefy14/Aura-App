import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/model/quiz/quiz_submit_model.dart';
import 'package:ready_lms/service/base_service/quiz.dart';
import 'package:ready_lms/utils/api_client.dart';

class QuizService extends Quiz {
  final Ref ref;
  QuizService(this.ref);

  @override
  Future<Response> startQuize({required int quizId}) {
    final response =
        ref.read(apiClientProvider).get('${AppConstants.startQuiz}$quizId');
    return response;
  }

  @override
  Future<Response> submitQuiz(
      {required QuizSubmitModel quizSubmitModel, required int quizSessionId}) {
    final response = ref.read(apiClientProvider).post(
      AppConstants.submitQuiz + quizSessionId.toString(),
      data: {'answer': quizSubmitModel.toJson()},
    );
    return response;
  }
}

final quizServiceProvider = Provider((ref) => QuizService(ref));
