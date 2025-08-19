import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/notification_model.dart';
import 'package:ready_lms/service/notification.dart';

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final Ref ref;
  NotificationNotifier(this.ref) : super(const AsyncValue.data([]));

  late int _totalNotificationCount;

  int get totalNotificationCount => _totalNotificationCount;

  Future<void> getNotification({
    required int itemPerPage,
    required int pageNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response =
          await ref.read(notificationServiceProvider).getNotifications(
                itemPerPage: itemPerPage,
                pageNumber: pageNumber,
              );
      _totalNotificationCount = response.data['data']['total_items'];
      final List<dynamic> list = response.data['data']['notifications'];

      var notifications =
          list.map((data) => NotificationModel.fromMap(data)).toList();
      if (pageNumber == 1) {
        state = AsyncValue.data(notifications);
      } else {
        notifications = [...state.value ?? [], ...notifications];
        state = AsyncValue.data(notifications);
      }
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await ref
          .read(notificationServiceProvider)
          .markALlNotificationAsRead();
      final List<dynamic> list = response.data['data']['notifications'];
      var notifications =
          list.map((data) => NotificationModel.fromMap(data)).toList();
      state = AsyncValue.data(notifications);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(int id) async {
    try {
      final response = await ref
          .read(notificationServiceProvider)
          .markNotificationAsRead(notificationId: id);
      final data = response.data['data']['notifications'];
      var notifications = NotificationModel.fromMap(data);
      replaceNotification(notifications);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void markReadInState(int id) {
    state = state.whenData((value) => [
          for (final item in value)
            item.id == id ? item.copyWith(isRead: true) : item
        ]);
  }

  void replaceNotification(NotificationModel notification) {
    state = state.whenData((value) => [
          for (final item in value)
            item.id == notification.id ? notification : item
        ]);
  }

  bool isUnReadExist() {
    return state.maybeWhen(
      data: (value) => value.any((element) => element.isRead == false),
      orElse: () => false,
    );
  }

  int unReadCount() {
    return state.maybeWhen(
      data: (value) => value.where((element) => element.isRead == false).length,
      orElse: () => 0,
    );
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier,
    AsyncValue<List<NotificationModel>>>(
  (ref) => NotificationNotifier(ref),
);
