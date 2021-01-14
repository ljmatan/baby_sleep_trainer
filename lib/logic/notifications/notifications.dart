import 'package:baby_sleep_scheduler/global/values.dart' as values;
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class Notifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future _onNotificationTapped(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    // Do something
  }

  static Future<void> init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('clock_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onNotificationTapped,
    );

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

  static Future<void> scheduleNotification() async =>
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Session time end',
        'You can check up on your baby now',
        tz.TZDateTime.now(tz.local).add(
          Duration(
            minutes: values.sessionTimes[Prefs.instance
                        .getString(values.Cached.sessionType.label) ??
                    'regular'][Prefs.instance.getInt(values.Cached.day.label)]
                [Prefs.instance.getInt(values.Cached.sessionNumber.label) ?? 0],
          ),
        ),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
}
