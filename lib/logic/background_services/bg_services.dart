/*
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:baby_sleep_scheduler/logic/vibration/vibration.dart';

abstract class BackgroundServices {
  static Future<void> init() async => await AndroidAlarmManager.initialize();

  static Future<void> registerVibration(Duration delay) async =>
      await AndroidAlarmManager.oneShot(delay, 0, VibrationServices.vibrate);

  static Future<void> cancelVibration() async =>
      await AndroidAlarmManager.cancel(0);
}
*/
