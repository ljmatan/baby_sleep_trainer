import 'dart:async';

import 'package:flutter/material.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:baby_sleep_scheduler/views/activity/delete_log_dialog.dart';

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

class LogEntry extends StatefulWidget {
  final int index;
  final Map log;
  final Function refresh;

  LogEntry({
    @required this.index,
    @required this.log,
    @required this.refresh,
  });

  @override
  State<StatefulWidget> createState() {
    return _LogEntryState();
  }
}

class _LogEntryState extends State<LogEntry> {
  final StreamController _columnSelectionController =
      StreamController.broadcast();

  void _select(String label) => _columnSelectionController.add(label);

  @override
  Widget build(BuildContext context) {
    final bool _longTime = widget.log['cryTime'] > 21600 ||
        widget.log['playTime'] > 21600 ||
        widget.log['totalTime'] > 21600;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        widget.index == 0 ? 16 : 0,
        16,
        12,
      ),
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
                        final bool rebuild = await showDialog(
                          context: context,
                          builder: (context) => DeleteLogDialog(
                            id: widget.log['id'],
                          ),
                        );
                        if (rebuild != null && rebuild) widget.refresh();
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
              /*if (widget.log['type'] == 'Unsuccessful' &&
                  widget.log['note'].isNotEmpty)
                Text(
                  widget.log['note'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),*/
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
