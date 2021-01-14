import 'package:baby_sleep_scheduler/views/help/night_theme_option.dart';
import 'package:flutter/material.dart';

class HelpView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelpViewState();
  }
}

class _HelpViewState extends State<HelpView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        NightThemeOption(),
      ],
    );
  }
}
