import 'package:vibrate/vibrate.dart';

abstract class Vibration {
  static bool _canVibrate;
  static bool get canVibrate => _canVibrate;

  static Future<void> init() async => _canVibrate = await Vibrate.canVibrate;

  static Future<void> vibrate() async =>
      canVibrate ? await Vibrate.vibrate() : print('Vibration unavailable');
}
