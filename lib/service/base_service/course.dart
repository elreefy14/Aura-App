import 'package:dio/dio.dart';

abstract class Course {
  Future<Response> courseList({
    required Map<String, dynamic>? query,
  });
  Future<Response> courseDetailByID({required int id});
  Future<Response> enrolledCourses({required int currentPage, int? parPage});
}
