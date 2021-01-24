import 'package:flutter_vibrate/flutter_vibrate.dart';

abstract class Vibration {
  static bool _canVibrate;

  static Future<void> init() async => _canVibrate = await Vibrate.canVibrate;

  // Pauses between each vibration
  static final Iterable<Duration> _pauses = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 500),
  ];

  static Future<void> vibrate() async => _canVibrate != null && _canVibrate
      ? await Vibrate.vibrateWithPauses(_pauses)
      : print('Vibration unavailable');
}
