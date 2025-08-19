import 'package:dio/dio.dart';

abstract class Certificate {
  Future<Response> getCertificateList({required int currentPage, int? parPage});
}
