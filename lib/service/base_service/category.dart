import 'package:dio/dio.dart';

abstract class Category {
  Future<Response> getCategories({Map<String, dynamic>? query});
}
