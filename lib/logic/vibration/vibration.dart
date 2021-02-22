import 'package:vibration/vibration.dart';

abstract class VibrationServices {
  static bool _canVibrate;

  static Future<void> init() async =>
      _canVibrate = await Vibration.hasVibrator();

  static Future<void> vibrate() async => init().whenComplete(() async =>
      _canVibrate ? await Vibration.vibrate() : print('Vibration unavailable'));
}
