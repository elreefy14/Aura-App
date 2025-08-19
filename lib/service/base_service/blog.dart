import 'package:dio/dio.dart';

abstract class Blog {
  Future<Response> getBlogs(
      {required int page, required int perPage, String? search});
  Future<Response> getBlogDetailsById({required int id});
}
