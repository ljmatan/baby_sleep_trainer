import 'dart:async';

import 'package:baby_sleep_scheduler/global/values.dart';

abstract class View {
  static Views _initial = Views.trainer;
  static Views get initial => _initial;

  static StreamController _streamController = StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void change(value) {
    _initial = value;
    _streamController.add(value);
  }

  static void dispose() => _streamController.close();
}
