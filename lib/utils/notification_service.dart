import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as latestTz;

class NotificationService {
  NotificationService._();

  static String pagePushRequest = '';

  static Future<void> initialize() async {
    latestTz.initializeTimeZones();
    await _initLocalNotifications();
    await _configureLocalTimeZone();
  }

  static Future<void> _configureLocalTimeZone() async {
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<void> _initLocalNotifications() async {
    await FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/farm'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          requestCriticalPermission: true,
          onDidReceiveLocalNotification: (id, title, body, payload) async {},
        ),
      ),
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'finca_local_channel',
        importance: Importance.max,
        priority: Priority.max,
      ),
      iOS: DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.critical,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    if (notificationResponse.payload == 'progress') {
      // Get.toNamed(Routes.progress);
    }
  }

  static Future<void> cancelScheduledNotifications() async {
    return FlutterLocalNotificationsPlugin().cancelAll();
  }

  static void scheduleWorkoutNotification(
    String notificationTitle,
    String notificationBody,
    DateTime startDate,
    DateTime endDate,
  ) async {
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      var scheduledDate = startDate.add(
        Duration(
          days: i,
          seconds: 5,
        ),
      );
      await FlutterLocalNotificationsPlugin().zonedSchedule(
        i,
        notificationTitle,
        notificationBody,
        tz.TZDateTime.from(scheduledDate, tz.getLocation(await FlutterTimezone.getLocalTimezone())),
        notificationDetails(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }
}
