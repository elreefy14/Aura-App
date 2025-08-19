import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/exam/answer.dart';
import 'package:ready_lms/model/exam/exam_question.dart';
import 'package:ready_lms/model/exam/exam_result_model.dart';
import 'package:ready_lms/service/exam_service.dart';

class ExamController extends StateNotifier<bool> {
  final Ref ref;
  ExamController(this.ref) : super(false);

  late ExamQustion _examQustion;
  ExamQustion get examQustion => _examQustion;

  Future<bool> startExam({required int examId}) async {
    state = true;
    try {
      final response =
          await ref.read(examServiceProvider).startExam(examId: examId);
      final status = response.statusCode == 201;
      if (status) {
        _examQustion = ExamQustion.fromJson(response.data['data']);
      }
      state = false;
      return status;
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return false;
    } finally {
      state = false;
    }
  }

  Future<ExamResultModel?> submitExam(
      {required List<Answer> answers, required int examId}) async {
    state = true;
    try {
      final response = await ref
          .read(examServiceProvider)
          .submitExam(answers: answers, examId: examId);
      final status = response.statusCode == 201;
      if (status) {
        return ExamResultModel.fromJson(response.data['data']);
      }
      state = false;
      return null;
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return null;
    } finally {
      state = false;
    }
  }
}

final examControllerProvider =
    StateNotifierProvider<ExamController, bool>((ref) => ExamController(ref));
