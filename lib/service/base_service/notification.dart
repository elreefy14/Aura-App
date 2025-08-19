import 'package:dio/dio.dart';

abstract class Notification {
  Future<Response> getNotifications({
    required int itemPerPage,
    required int pageNumber,
  });
  Future<Response> markNotificationAsRead({required int notificationId});
  Future<Response> markALlNotificationAsRead();
}
