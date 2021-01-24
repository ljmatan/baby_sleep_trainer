import 'dart:async';

import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CustomTheme {
  static bool _nightTheme;
  static bool get nightTheme => _nightTheme;

  static void init() =>
      _nightTheme = Prefs.instance.getBool('nightTheme') ?? false;

  static final StreamController _streamController =
      StreamController.broadcast();

  static Stream get stream => _streamController.stream;

  static void change(value) {
    _nightTheme = value;
    _streamController.add(value);
    if (value)
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    else
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
  }

  static ThemeData get themeData => ThemeData(
        fontFamily: 'Oswald',
        accentColor: Colors.white,
        primaryColor: const Color(0xff9d8bc4),
        scaffoldBackgroundColor: _nightTheme ? Colors.black : Colors.grey[50],
        iconTheme:
            IconThemeData(color: _nightTheme ? Colors.white : Colors.black),
        textTheme: TextTheme(
          bodyText2:
              TextStyle(color: _nightTheme ? Colors.white : Colors.black),
        ),
      );
}
