import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/material.dart';

class NightThemeOption extends StatefulWidget {
  final Function refresh;

  NightThemeOption(this.refresh);

  @override
  State<StatefulWidget> createState() {
    return _NightThemeOptionState();
  }
}

class _NightThemeOptionState extends State<NightThemeOption> {
  bool _value = Values.nightTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dark Theme',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Oswald',
            ),
          ),
          Switch(
            value: _value,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) async {
              await Values.setNightTheme(value);
              setState(() => _value = value);
              CustomTheme.change(value);
              widget.refresh();
            },
          ),
        ],
      ),
    );
  }
}
