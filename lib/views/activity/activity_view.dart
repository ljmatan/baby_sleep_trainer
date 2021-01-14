import 'dart:async';

import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:baby_sleep_scheduler/views/activity/graph.dart';
import 'package:flutter/material.dart';

class ChartColumn extends StatelessWidget {
  final String label;
  final int value, color;
  final bool longTime;
  final Function(String) select;

  ChartColumn({
    @required this.label,
    @required this.value,
    @required this.color,
    @required this.longTime,
    @required this.select,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
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
                  height: (value / (longTime ? 43200 : 21600)) * 120,
                  width: 35,
                ),
              ),
            ),
          ],
        ),
        onTap: () => select(label),
      ),
    );
  }
}

class Log extends StatefulWidget {
  final int index;
  final Map log;
  final Function refresh;

  Log({
    @required this.index,
    @required this.log,
    @required this.refresh,
  });

  @override
  State<StatefulWidget> createState() {
    return _LogState();
  }
}

class _LogState extends State<Log> {
  final StreamController _columnSelectionController =
      StreamController.broadcast();

  void _select(String label) => _columnSelectionController.add(label);

  @override
  Widget build(BuildContext context) {
    final bool _longTime = widget.log['cryTime'] > 21600 ||
        widget.log['playTime'] > 21600 ||
        widget.log['totalTime'] > 21600;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CustomTheme.nightTheme ? Colors.black : Colors.white,
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
                      'Day ${widget.log['day'] + 1} - ${widget.log['type']} training',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Icon(Icons.delete),
                      onTap: () async {
                        await DB.db.rawDelete(
                          'DELETE FROM Logs WHERE id = ${widget.log['id']}',
                        );
                        widget.refresh();
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
                            label: 'Crying',
                            value: widget.log['cryTime'],
                            longTime: _longTime,
                            color: 0xff212930,
                            select: _select,
                          ),
                          ChartColumn(
                            label: 'Playing',
                            value: widget.log['playTime'],
                            longTime: _longTime,
                            color: 0xff855723,
                            select: _select,
                          ),
                          ChartColumn(
                            label: 'Sleeping',
                            value: widget.log['totalTime'],
                            longTime: _longTime,
                            color: 0xff008000,
                            select: _select,
                          ),
                          ChartColumn(
                            label: 'Until asleep',
                            value:
                                widget.log['playTime'] + widget.log['cryTime'],
                            longTime: _longTime,
                            color: 0xff9f9b74,
                            select: _select,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      width: 30,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: StreamBuilder(
                          stream: _columnSelectionController.stream,
                          builder: (context, selected) => Text(
                            (selected.hasData ? selected.data : '')
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Oswald',
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.log['type'] == 'Unsuccessful' &&
                  widget.log['note'].isNotEmpty)
                Text(
                  widget.log['note'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              if (widget.index == 0)
                const Text(
                  'Tap one of the columns for more info',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _columnSelectionController.close();
    super.dispose();
  }
}

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
  Future<List<Map<String, dynamic>>> _getLogs() async {
    final result = await DB.db.rawQuery(
      'SELECT * FROM Logs WHERE type IS NOT NULL',
    );

    return result;
  }

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
                        SizedBox(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 270
                              : MediaQuery.of(context).size.height - 60,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: StackedAreaLineChart(logs.data),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
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
                          Log(index: i, log: logs.data[i], refresh: refresh),
                      ],
                    )
                  : Center(child: Text('No recorded logs!'))
              : Center(child: CircularProgressIndicator()),
    );
  }
}
