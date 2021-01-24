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

    List<SleepData> sleep = [];

    for (var i = 0; i <= _sessionDays; i++) {
      for (var log in widget.logs) if (log['day'] == i) time += log[mode] / 60;
      sleep.add(SleepData(i + 1, time.round(), 'Sleep'));
      time = 0;
    }

    return [
      charts.Series<SleepData, String>(
        id: 'Sleep',
        data: sleep,
        colorFn: (SleepData sales, __) => charts.Color(
          r: mode == 'totalTime'
              ? 0
              : mode == 'cryTime'
                  ? 2
                  : 133,
          g: mode == 'totalTime'
              ? 128
              : mode == 'cryTime'
                  ? 7
                  : 87,
          b: mode == 'totalTime'
              ? 0
              : mode == 'cryTime'
                  ? 93
                  : 35,
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
      initialData: 'totalTime',
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
