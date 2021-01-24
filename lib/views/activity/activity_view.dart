import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/views/activity/clear_logs/clear_logs_button.dart';
import 'package:baby_sleep_scheduler/views/activity/summary_graph/controller.dart';
import 'package:baby_sleep_scheduler/views/activity/summary_graph/graph_mode_selection.dart';
import 'summary_graph/graph.dart';
import 'package:baby_sleep_scheduler/views/activity/log_entry/log_entry.dart';
import 'package:flutter/material.dart';

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
  void initState() {
    super.initState();
    GraphController.init();
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
              ? ListView(
                  children: [
                    GraphModeButtons(),
                    SizedBox(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 270
                          : MediaQuery.of(context).size.height - 100,
                      child: Stack(
                        children: [
                          StackedAreaLineChart(logs.data),
                          if (!(logs.hasData && logs.data.isNotEmpty))
                            Center(child: Text('No recorded logs!')),
                        ],
                      ),
                    ),
                    if (logs.hasData && logs.data.isNotEmpty)
                      ClearLogsButton(refresh: refresh),
                    if (logs.hasData && logs.data.isNotEmpty)
                      for (var i = 0; i < logs.data.length; i++)
                        LogEntry(
                          index: i,
                          log: logs.data[i],
                          refresh: refresh,
                        ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    GraphController.dispose();
    super.dispose();
  }
}
