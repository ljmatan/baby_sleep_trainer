import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SleepData {
  final int day;
  final int time;
  final String label;

  SleepData(this.day, this.time, this.label);
}

class StackedAreaLineChart extends StatefulWidget {
  final List<Map<String, dynamic>> logs;

  StackedAreaLineChart(this.logs);

  @override
  State<StatefulWidget> createState() {
    return _StackedAreaLineChartState();
  }
}

class _StackedAreaLineChartState extends State<StackedAreaLineChart> {
  List<charts.Series<SleepData, String>> _seriesList() {
    // Number of days trained
    int _sessionDays = 0;

    // Get number of days trained
    for (var log in widget.logs)
      if (log['day'] > _sessionDays) _sessionDays = log['day'];

    List<SleepData> crying = [];

    double time = 0;

    for (var i = 0; i <= _sessionDays; i++) {
      for (var log in widget.logs)
        if (log['day'] == i) time += log['cryTime'] / 60;
      crying.add(SleepData(i + 1, time.round(), 'Crying'));
    }

    time = 0;

    List<SleepData> playing = [];

    for (var i = 0; i <= _sessionDays; i++) {
      for (var log in widget.logs)
        if (log['day'] == i) time += log['playTime'] / 60;
      playing.add(SleepData(i + 1, time.round(), 'Playing'));
    }

    time = 0;

    List<SleepData> sleep = [];

    for (var i = 0; i <= _sessionDays; i++) {
      for (var log in widget.logs)
        if (log['day'] == i) time += log['totalTime'] / 60;
      sleep.add(SleepData(i + 1, time.round(), 'Sleep'));
    }

    time = 0;

    List<SleepData> timeToSleep = [];

    for (var i = 0; i <= _sessionDays; i++) {
      for (var log in widget.logs)
        if (log['day'] == i) {
          time += log['cryTime'] / 60;
          time += log['playTime'] / 60;
        }
      timeToSleep.add(SleepData(i + 1, time.round(), 'Until asleep'));
    }

    return [
      charts.Series<SleepData, String>(
        id: 'Crying',
        data: crying,
        colorFn: (SleepData sales, __) => charts.Color(r: 87, g: 82, b: 126),
        domainFn: (SleepData sales, _) => 'Day ${sales.day}',
        measureFn: (SleepData sales, _) => sales.time,
      ),
      charts.Series<SleepData, String>(
        id: 'Playing',
        data: playing,
        colorFn: (SleepData sales, __) => charts.Color(r: 137, g: 32, b: 52),
        domainFn: (SleepData sales, _) => 'Day ${sales.day}',
        measureFn: (SleepData sales, _) => sales.time,
      ),
      charts.Series<SleepData, String>(
        id: 'Sleep',
        data: sleep,
        colorFn: (SleepData sales, __) => charts.Color(r: 0, g: 128, b: 0),
        domainFn: (SleepData sales, _) => 'Day ${sales.day}',
        measureFn: (SleepData sales, _) => sales.time,
      ),
      charts.Series<SleepData, String>(
        id: 'Time till sleep',
        data: timeToSleep,
        colorFn: (SleepData sales, __) => charts.Color(r: 159, g: 155, b: 116),
        domainFn: (SleepData sales, _) => 'Day ${sales.day}',
        measureFn: (SleepData sales, _) => sales.time,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _seriesList(),
      animate: false,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      barGroupingType: charts.BarGroupingType.grouped,
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }
}
