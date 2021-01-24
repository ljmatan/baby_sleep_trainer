import 'dart:async';

import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CustomTheme {
  static bool _nightTheme;
  static bool get nightTheme => _nightTheme;

  /// Set status and navigation bar colors
  static void _setSystemColors() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: nightTheme ? Colors.black : Colors.white,
          statusBarIconBrightness:
              nightTheme ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness:
              nightTheme ? Brightness.light : Brightness.dark,
        ),
      );

  static void init() {
    _nightTheme = Values.nightTheme;
    _setSystemColors();
  }

  static final StreamController _streamController =
      StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void change(value) {
    _nightTheme = value;
    _streamController.add(value);
    _setSystemColors();
  }

  static ThemeData get themeData => ThemeData(
        fontFamily: 'Oswald',
        primaryColor: const Color(0xff9d8bc4),
        accentColor: const Color(0xff9d8bc4),
        scaffoldBackgroundColor: nightTheme ? Colors.black : Colors.grey[50],
        iconTheme:
            IconThemeData(color: nightTheme ? Colors.white : Colors.black),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: nightTheme ? Colors.white : Colors.black),
        ),
        backgroundColor: nightTheme ? Colors.black : Colors.white,
      );
}
