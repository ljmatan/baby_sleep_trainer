import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/views/activity/graph.dart';
import 'package:baby_sleep_scheduler/views/activity/log_entry/log_entry.dart';
import 'package:flutter/material.dart';

class ColorLabel extends StatelessWidget {
  final double leftPadding;
  final int color;
  final String label;

  ColorLabel({
    @required this.leftPadding,
    @required this.color,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 12, height: 12),
          ),
          Text('  $label'),
        ],
      ),
    );
  }
}

class ActivityView extends StatefulWidget {
  static _ActivityViewState _state;
  static _ActivityViewState get state => _state;

  @override
  State<StatefulWidget> createState() {
    _state = _ActivityViewState();
    return state;
  }
}

class _ActivityViewState extends State<ActivityView> {
  Future<List<Map<String, dynamic>>> _getLogs() async => await DB.db.rawQuery(
        'SELECT * FROM Logs WHERE type IS NOT NULL',
      );

  Key _key = UniqueKey();

  void refresh() {
    if (mounted) setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: _key,
      future: _getLogs(),
      builder: (context, logs) => logs.hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(logs.error.toString(), textAlign: TextAlign.center),
              ),
            )
          : logs.connectionState == ConnectionState.done
              ? logs.hasData && logs.data.isNotEmpty
                  ? ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Sleep Summary',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 270
                              : MediaQuery.of(context).size.height - 60,
                          child: StackedAreaLineChart(logs.data),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ColorLabel(
                                leftPadding: 0,
                                color: 0xff57527e,
                                label: 'Crying',
                              ),
                              ColorLabel(
                                leftPadding: 8,
                                color: 0xff892034,
                                label: 'Playing',
                              ),
                              ColorLabel(
                                leftPadding: 8,
                                color: 0xff008000,
                                label: 'Sleeping',
                              ),
                              ColorLabel(
                                leftPadding: 8,
                                color: 0xff9f9b74,
                                label: 'Until asleep',
                              ),
                            ],
                          ),
                        ),
                        for (var i = 0; i < logs.data.length; i++)
                          LogEntry(
                            index: i,
                            log: logs.data[i],
                            refresh: refresh,
                          ),
                      ],
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Your baby\'s sleep data will be displayed here.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
