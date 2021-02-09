import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/notifications/notifications.dart';
import 'package:baby_sleep_scheduler/views/trainer/sleep/bloc/sleep_session.dart';
import 'package:flutter/material.dart';

class AlarmOption extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlarmOptionState();
  }
}

class _AlarmOptionState extends State<AlarmOption> {
  bool _value = Values.alarms;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 4, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Alarms',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: _value,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) async {
              await Values.setAlarms(value);
              setState(() => _value = value);
              if (!value)
                await Notifications.clear();
              else {
                if (SleepSession.data == States.crying.label)
                  await Notifications.scheduleNotification();
              }
            },
          ),
        ],
      ),
    );
  }
}
