import 'package:dio/dio.dart';

abstract class CheckOut {
  Future<Response> courseDetailByID({required int id});
  Future<Response> couponValidate({required String code});
  Future<Response> enrollCourseById(
      {required int id, int couponId, required Map<String, dynamic> query});
}
