import 'package:flutter/material.dart';

class SessionTimer extends StatelessWidget {
  final Stream stream;
  final int initial;

  SessionTimer({@required this.stream, @required this.initial});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      initialData: initial,
      builder: (context, totalTime) {
        int totalTimeInSeconds, hours, minutes, seconds;

        totalTimeInSeconds = totalTime.data;

        if (totalTimeInSeconds < 0) totalTimeInSeconds = 0;

        hours =
            ((totalTimeInSeconds - (totalTimeInSeconds % 3600)) / 3600).round();
        final int minutesRemainder = totalTimeInSeconds - hours * 3600;
        minutes = ((minutesRemainder - (minutesRemainder % 60)) / 60).round();
        seconds = (totalTimeInSeconds - hours * 3600 - minutes * 60).round();

        return Text(
          (hours < 10 ? '0$hours' : '$hours') +
              ':' +
              (minutes < 10 ? '0$minutes' : '$minutes') +
              ':' +
              (seconds < 10 ? '0$seconds' : '$seconds'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
