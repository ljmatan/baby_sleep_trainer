import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/material.dart';

class NightThemeOption extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NightThemeOptionState();
  }
}

class _NightThemeOptionState extends State<NightThemeOption> {
  bool _value = CustomTheme.nightTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dark Theme',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Switch(
            value: _value,
            onChanged: (value) async {
              await Prefs.instance.setBool('nightTheme', value);
              setState(() => _value = value);
              CustomTheme.change(value);
            },
          ),
        ],
      ),
    );
  }
}
