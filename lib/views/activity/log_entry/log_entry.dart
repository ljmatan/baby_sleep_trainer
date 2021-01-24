import 'package:baby_sleep_scheduler/views/activity/log_entry/column_label.dart';
import 'package:flutter/material.dart';
import 'delete_log_dialog.dart';

class ChartColumn extends StatelessWidget {
  final int value, color;
  final bool longTime;

  ChartColumn({
    @required this.value,
    @required this.color,
    @required this.longTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: value <= 30 ? 0 : 12),
            child: Text(
              '${(value / 60).round()}\nmin',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
          LimitedBox(
            maxHeight: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(color)),
              child: SizedBox(
                width: 35,
                height: (value / (longTime ? 43200 : 21600)) * 120,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogEntry extends StatelessWidget {
  final int index;
  final Map log;
  final Function refresh;

  LogEntry({
    @required this.index,
    @required this.log,
    @required this.refresh,
  });

  final List<int> _colors = const [
    0xff02075d,
    0xff855723,
    0xff008000,
    0xff9f9b74,
  ];

  final List<String> _labels = const [
    'Crying',
    'Awake',
    'Sleeping',
    'Until asleep',
  ];

  @override
  Widget build(BuildContext context) {
    final bool _longTime = log['cryTime'] > 21600 ||
        log['playTime'] > 21600 ||
        log['totalTime'] > 21600 ||
        log['cryTime'] + log['playTime'] > 21600;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Day ${log['day'] + 1} - ${log['type']} training',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Icon(Icons.delete, size: 22),
                      onTap: () async {
                        final bool rebuild = await showDialog(
                          context: context,
                          builder: (context) => DeleteLogDialog(id: log['id']),
                        );
                        if (rebuild != null && rebuild) refresh();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      child: SizedBox(
                        height: 120,
                        width: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_longTime) Text('12h'),
                            Text('6h'),
                            if (!_longTime) Text('3h'),
                            Text('0h'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ChartColumn(
                            value: log['cryTime'],
                            longTime: _longTime,
                            color: _colors[0],
                          ),
                          ChartColumn(
                            value: log['playTime'],
                            longTime: _longTime,
                            color: _colors[1],
                          ),
                          ChartColumn(
                            value: log['totalTime'],
                            longTime: _longTime,
                            color: _colors[2],
                          ),
                          ChartColumn(
                            value: log['playTime'] + log['cryTime'],
                            longTime: _longTime,
                            color: _colors[3],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120, width: 30),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 4; i++)
                    ColumnLabel(
                      leftPadding: i == 0 ? 0 : 8,
                      color: _colors[i],
                      label: _labels[i],
                    ),
                ],
              ),
              if (log['type'] == 'Unsuccessful' && log['note'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    log['note'],
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
