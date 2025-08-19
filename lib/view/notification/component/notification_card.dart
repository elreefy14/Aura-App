import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/model/notification_model.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../../controllers/notification.dart';

class NotificationCard extends ConsumerWidget {
  final NotificationModel model;
  const NotificationCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        _onTapForNotification(context: context);
        if (model.isRead == false) {
          ref.read(notificationProvider.notifier).markReadInState(model.id!);
          ref
              .read(notificationProvider.notifier)
              .markNotificationAsRead(model.id!);
        }
      },
      tileColor: !model.isRead! ? context.color.surfaceContainerHighest : null,
      title: Text(model.heading!),
      subtitle: Row(
        children: [
          Text(model.dateFormat!),
          8.pw,
          CircleAvatar(
            radius: 3.r,
            backgroundColor: AppStaticColor.grayColor,
          ),
          8.pw,
          Text(model.createdAt!),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (model.isRead == false)
            CircleAvatar(
              radius: 4.r,
              backgroundColor: context.color.primary,
            ),
        ],
      ),
      leading: CircleAvatar(
        radius: 15.r,
        backgroundImage: NetworkImage(
          model.logo!,
        ),
      ),
    );
  }

  void _onTapForNotification({required BuildContext context}) {
    print('This is a type of notification: ${model.type}');
    final notificationType = getNotificationType(model.type!);
    if (notificationType == null) {
      debugPrint('Unknown notification type: ${model.type}');
      return;
    }
    // print(model.type);
    switch (notificationType) {
      case NotificationType.new_enrollment_notification:
        context.nav
            .pushNamed(Routes.myCourseDetails, arguments: model.courseId);
        break;
      case NotificationType.new_custom_notification_from_admin:
        print('No need to navigate');
        break;
      case NotificationType.new_quiz_from_course:
        print('navigate to course details');
        break;
      case NotificationType.new_exam_from_course:
        print('navigate to course details');
        break;
      case NotificationType.new_course_from_instructor:
        context.nav.pushNamed(Routes.courseNew,
            arguments: {'courseId': model.courseId});
        break;
      case NotificationType.new_content_from_course:
        context.nav
            .pushNamed(Routes.myCourseDetails, arguments: model.courseId);
        break;
    }
  }

  NotificationType? getNotificationType(String type) {
    switch (type) {
      case 'new_enrollment_notification':
        return NotificationType.new_enrollment_notification;
      case 'new_custom_notification_from_admin':
        return NotificationType.new_custom_notification_from_admin;
      case 'new_quiz_from_course':
        return NotificationType.new_quiz_from_course;
      case 'new_exam_from_course':
        return NotificationType.new_exam_from_course;
      case 'new_course_from_instructor':
        return NotificationType.new_course_from_instructor;
      case 'new_content_from_course':
        return NotificationType.new_content_from_course;

      default:
        return null;
    }
  }
}

NotificationType? getNotificationType(String type) {
  switch (type) {
    case 'new_enrollment_notification':
      return NotificationType.new_enrollment_notification;
    case 'new_custom_notification_from_admin':
      return NotificationType.new_custom_notification_from_admin;
    case 'new_quiz_from_course':
      return NotificationType.new_quiz_from_course;
    case 'new_exam_from_course':
      return NotificationType.new_exam_from_course;
    case 'new_course_from_instructor':
      return NotificationType.new_course_from_instructor;
    case 'new_content_from_course':
      return NotificationType.new_content_from_course;
    default:
      return null;
  }
}

enum NotificationType {
  new_enrollment_notification,
  new_custom_notification_from_admin,
  new_quiz_from_course,
  new_exam_from_course,
  new_course_from_instructor,
  new_content_from_course,
}
