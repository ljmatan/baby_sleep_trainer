import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/views/trainer/sleep/bloc/sleep_session.dart';
import 'package:baby_sleep_scheduler/views/trainer/sleep/timer/animated_guide.dart';
import 'package:flutter/material.dart';
import 'timer.dart';

class CenterTimer extends StatelessWidget {
  final Stream stream;
  final int initial;
  final bool cryTimeOver;

  CenterTimer({
    @required this.stream,
    @required this.initial,
    @required this.cryTimeOver,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: SleepSession.stream,
            initialData: SleepSession.data,
            builder: (context, mode) => Text(
              mode.data == States.crying.label
                  ? 'wait for'
                  : mode.data == States.playing.label
                      ? 'awake time'
                      : 'sleep time',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
          SessionTimer(stream: stream, initial: initial),
          if (cryTimeOver) AnimatedGuide(),
        ],
      ),
    );
  }
}
