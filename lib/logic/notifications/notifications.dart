import 'dart:io' as io show Platform;

import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/background_services/bg_services.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class Notifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('0', 'none', 'none',
          importance: Importance.max, priority: Priority.high, showWhen: true);
  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  static Future<void> scheduleNotification() async {
    if (Values.alarms) {
      final int sessionNubmer =
          Prefs.instance.getInt(Cached.sessionNumber.label);
      final int delay = sessionTimes[
              Prefs.instance.getString(Cached.sessionType.label) ??
                  'regular'][Prefs.instance.getInt(Cached.day.label)]
          [sessionNubmer == null
              ? 0
              : sessionNubmer <= 3
                  ? sessionNubmer
                  : 3];

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Session time end',
        'You can check up on your baby now',
        tz.TZDateTime.now(tz.local).add(Duration(minutes: delay)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      if (io.Platform.isAndroid)
        await BackgroundServices.registerVibration(Duration(minutes: delay));
    }
  }

  /// Cancel any currently scheduled notification.
  static Future<void> clear() async {
    if (Values.alarms) await flutterLocalNotificationsPlugin.cancel(0);
    await BackgroundServices.cancelVibration();
  }
}
