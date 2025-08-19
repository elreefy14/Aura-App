import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../firebase_options.dart';
import '../routes.dart';
import '../view/notification/component/notification_card.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> firebaseMessagingForgroundHandler() async {
  try {
  FirebaseMessaging.onMessage.listen((message) {
      try {
    debugPrint(message.data.toString());
    debugPrint(message.toString());
    debugPrint('Handling a ForeGround message ${message.toMap()}');
    debugPrint('Handling a ForeGround message ${message.messageId}');
    debugPrint('Handling a ForeGround message ${message.notification?.body}');
    showFlutterNotification(message);
      } catch (e) {
        debugPrint('Error handling foreground message: $e');
      }
  });
  } catch (e) {
    debugPrint('Error setting up foreground message handler: $e');
  }
}

// Declare and initialize the FlutterLocalNotificationsPlugin
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  // Initialize the FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@drawable/notification_icon'),
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveLocalNotification,
    onDidReceiveNotificationResponse: onSelectNotification,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  try {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  final AppleNotification? iOS = message.notification?.apple;

  if (notification != null && (android != null || iOS != null) && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/notification_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
    }
  } catch (e) {
    debugPrint('Error showing flutter notification: $e');
  }
}

void handleMessage(NotificationResponse? notificationResponse) {
  if (notificationResponse?.payload != null) {
    // Decide the JSON payload
    final Map<String, dynamic> payloadData =
        jsonDecode(notificationResponse!.payload!);
    print('Parsed payload data: $payloadData');
    final int? courseId = int.tryParse(payloadData['courseId']);
    final notificationType = getNotificationType(payloadData['type']);
    if (notificationType == null) {
      debugPrint('Unknown notification type: ${payloadData['type']}');
      return;
    }
    switch (notificationType) {
      case NotificationType.new_enrollment_notification:
        ApGlobalFunctions.navigatorKey.currentContext?.nav.pushNamed(
          Routes.myCourseDetails,
          arguments: courseId,
        );
        break;
      case NotificationType.new_custom_notification_from_admin:
        break;
      case NotificationType.new_quiz_from_course:
        break;
      case NotificationType.new_exam_from_course:
        break;

      case NotificationType.new_course_from_instructor:
        ApGlobalFunctions.navigatorKey.currentContext?.nav.pushNamed(
          Routes.courseNew,
          arguments: {'courseId': courseId},
        );
        break;
      case NotificationType.new_content_from_course:
        ApGlobalFunctions.navigatorKey.currentContext?.nav.pushNamed(
          Routes.myCourseDetails,
          arguments: courseId,
        );
        break;
    }
  } else {
    debugPrint('No payload available');
  }
}

// Background notification selection
Future<void> onDidReceiveLocalNotification(
  NotificationResponse notificationResponse,
) async {
  // Handle background notification selection
}

// Foreground notification selection
Future<void> onSelectNotification(
  NotificationResponse notificationResponse,
) async {
  // Handle foreground notification selection
  handleMessage(notificationResponse);
}
