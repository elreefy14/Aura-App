import 'package:dio/dio.dart';

abstract class MyCourse {
  Future<Response> courseDetailByID({required int id});
  Future<Response> makeContentView({required int id});
}
