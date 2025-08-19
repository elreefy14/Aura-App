import 'package:dio/dio.dart';

abstract class Favourite {
  Future<Response> getFavouriteList(
      {String? guestId, required int currentPage, int? parPage});
  Future<Response> FavouriteUpdate({required int courseId, String? guestId});
}
