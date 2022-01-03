import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi2 {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            importance: Importance.max),
        iOS: IOSNotificationDetails(
            sound: 'a_long_cold_sting.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true));
  }

  static Future init({bool initScheduled = false}) async {
    const andriod = AndroidInitializationSettings("icon");
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: andriod, iOS: iOS);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required Time scheduledTime,
  }) async {
    _notifications.zonedSchedule(id, title, body,
        _scheduledDaily(scheduledTime), await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload);
  }

  static tz.TZDateTime _scheduledDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static Future cancelNotification() async {
    await _notifications.cancelAll();
  }
}
