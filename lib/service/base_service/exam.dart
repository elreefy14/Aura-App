import 'package:dio/dio.dart';
import 'package:ready_lms/model/exam/answer.dart';

abstract class Exam {
  Future<Response> startExam({required int examId});
  Future<Response> submitExam(
      {required List<Answer> answers, required int examId});
}
