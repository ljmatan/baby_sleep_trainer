import 'package:baby_sleep_scheduler/views/help/alarm_option.dart';
import 'package:baby_sleep_scheduler/views/help/night_theme_option.dart';
import 'package:baby_sleep_scheduler/views/help/q_and_a.dart';
import 'package:flutter/material.dart';

class HelpView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelpViewState();
  }
}

class _HelpViewState extends State<HelpView> {
  Key _key = UniqueKey();
  void _refresh() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        NightThemeOption(_refresh),
        AlarmOption(),
        QandA(_key),
      ],
    );
  }
}
