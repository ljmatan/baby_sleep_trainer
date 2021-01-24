import 'dart:async';

import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';

abstract class SleepSession {
  static bool _paused = Prefs.instance.getBool(Cached.paused.label);
  static void setPaused(bool value) => _paused = value;

  static States _state =
      _paused != null && !_paused ? States.sleeping : States.playing;
  static void setSessionState(States value) => _state = value;

  static String _data = _paused != null
      ? _paused
          ? _state.label
          : States.sleeping.label
      : States.playing.label;

  static String get data => _data;

  static StreamController _streamController;

  static void init() => _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void change(value) {
    _streamController.add(value);
    _data = value;
  }

  static void dispose() => _streamController.close();
}
