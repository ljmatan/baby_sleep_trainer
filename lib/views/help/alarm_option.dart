import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/material.dart';

class AlarmOption extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlarmOptionState();
  }
}

class _AlarmOptionState extends State<AlarmOption> {
  bool _value = Prefs.instance.getBool('alarms') ?? true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 4, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Alarms',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Switch(
            value: _value,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) async {
              await Prefs.instance.setBool('alarms', value);
              setState(() => _value = value);
            },
          ),
        ],
      ),
    );
  }
}
