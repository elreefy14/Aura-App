import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/model/exam/answer.dart';
import 'package:ready_lms/service/base_service/exam.dart';
import 'package:ready_lms/utils/api_client.dart';

class ExamService extends Exam {
  final Ref ref;
  ExamService(this.ref);

  @override
  Future<Response> startExam({required int examId}) {
    final response =
        ref.read(apiClientProvider).get('${AppConstants.startExam}$examId');
    return response;
  }

  @override
  Future<Response> submitExam(
      {required List<Answer> answers, required int examId}) {
    final response = ref.read(apiClientProvider).post(
        '${AppConstants.submitExam}$examId',
        data: {'answers': answers.map((e) => e.toJson()).toList()});
    return response;
  }
}

final examServiceProvider = Provider((ref) => ExamService(ref));
