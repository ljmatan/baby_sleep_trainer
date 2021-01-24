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
      padding: const EdgeInsets.fromLTRB(16, 16, 4, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dark Theme',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Switch(
            value: _value,
            activeColor: Theme.of(context).primaryColor,
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
