/*
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

abstract class VibrationServices {
  static Future<bool> canVibrate() async => await Vibration.hasVibrator();

  static Future<void> vibrate() async {
    final DateTime notificationTime = DateTime.parse(
        (await SharedPreferences.getInstance()).getString('notification time'));
    canVibrate().then((canVibrate) async => canVibrate
        ? notificationTime.isAfter(DateTime.now())
            ? await Vibration.vibrate(
                duration:
                    notificationTime.difference(DateTime.now()).inMilliseconds)
            : print('Vibration did not run - too late')
        : print('Vibration unavailable'));
  }
}
*/
