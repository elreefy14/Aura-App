import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/service/base_service/notification.dart';
import 'package:ready_lms/utils/api_client.dart';

class NotificationService implements Notification {
  final Ref ref;
  NotificationService(this.ref);
  @override
  Future<Response> getNotifications({
    required int itemPerPage,
    required int pageNumber,
  }) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.notificiations, query: {
      AppConstants.page: '$pageNumber',
      AppConstants.perPage: '$itemPerPage'
    });
    return response;
  }

  @override
  Future<Response> markALlNotificationAsRead() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstants.notificationReadAll,
        );
    return response;
  }

  @override
  Future<Response> markNotificationAsRead({required int notificationId}) {
    final response = ref.read(apiClientProvider).get(
          '${AppConstants.notificationRead}/$notificationId',
        );
    return response;
  }
}

final notificationServiceProvider =
    Provider<Notification>((ref) => NotificationService(ref));
