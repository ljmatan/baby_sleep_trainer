import 'package:baby_sleep_scheduler/views/activity/summary_graph/controller.dart';
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
  List<charts.Series<SleepData, String>> _seriesList(String mode) {
    // Number of days trained
    int _sessionDays = 6;

    // Get number of days trained
    for (var log in widget.logs)
      if (log['day'] > _sessionDays) _sessionDays = log['day'];

    double time = 0;

    List<SleepData> data = [];

    for (var i = 0; i <= _sessionDays; i++) {
      for (var log in widget.logs)
        if (log['day'] == i) {
          if (mode == 'awakeTime') {
            if (log['awakeTime'] / 60 > time) time = log['awakeTime'] / 60;
          } else if (mode == 'other') {
            time += (log['cryTime']) / 60;
          } else
            time += log[mode] / 60;
        }

      if (mode == 'other') {
        double highest = 0;
        for (var log in widget.logs)
          if (log['day'] == i) if (log['awakeTime'] / 60 > highest)
            highest = log['awakeTime'] / 60;
        time += highest;
      }

      data.add(SleepData(i + 1, time.round(), 'Sleep'));
      time = 0;
    }

    return [
      charts.Series<SleepData, String>(
        id: 'none',
        data: data,
        colorFn: (SleepData sales, __) => charts.Color(
          r: mode == 'totalTime'
              ? 253
              : mode == 'cryTime'
                  ? 244
                  : mode == 'awakeTime'
                      ? 133
                      : 200,
          g: mode == 'totalTime'
              ? 227
              : mode == 'cryTime'
                  ? 169
                  : mode == 'awakeTime'
                      ? 219
                      : 161,
          b: mode == 'totalTime'
              ? 166
              : mode == 'cryTime'
                  ? 189
                  : mode == 'awakeTime'
                      ? 210
                      : 114,
        ),
        domainFn: (SleepData sales, _) => 'Day ${sales.day}',
        measureFn: (SleepData sales, _) => sales.time,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GraphController.stream,
      initialData: 'cryTime',
      builder: (context, mode) => charts.BarChart(
        _seriesList(mode.data),
        animate: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
        ),
      ),
    );
  }
}
