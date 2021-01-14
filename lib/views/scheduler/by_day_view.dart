import 'dart:async';

import 'package:baby_sleep_scheduler/global/values.dart' as values;
import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final int day, session, initial;
  final Function refresh;

  TimePicker({
    @required this.day,
    @required this.session,
    @required this.initial,
    @required this.refresh,
  });

  @override
  State<StatefulWidget> createState() {
    return _TimePickerState();
  }
}

class _TimePickerState extends State<TimePicker> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        FixedExtentScrollController(initialItem: widget.initial - 1);
  }

  Future<void> _changeTime(int time) async {
    if (time > 0) {
      final List<Map<String, dynamic>> result = await DB.db.rawQuery(
        'SELECT * FROM CustomTimes WHERE day = ${widget.day} AND session = ${widget.session} LIMIT 1',
      );

      if (result.isEmpty)
        await DB.db.rawInsert(
          'INSERT INTO CustomTimes(day, session, time) '
          'VALUES(${widget.day}, ${widget.session}, $time)',
        );
      else
        await DB.db.rawUpdate(
          'UPDATE CustomTimes SET time = ? WHERE day = ? AND session = ?',
          [time, widget.day, widget.session],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: (MediaQuery.of(context).size.width - 32) / 4,
      child: CupertinoPicker(
        itemExtent: 48,
        scrollController: _scrollController,
        children: [
          for (var i = 1; i <= 60; i++)
            Text(
              '$i',
              style: TextStyle(
                color: CustomTheme.nightTheme ? Colors.white : Colors.black,
              ),
            ),
        ],
        onSelectedItemChanged: (i) async {
          await _changeTime(i + 1);
          await values.initSessionTimes();
          widget.refresh();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class EditDialog extends StatelessWidget {
  final int day;
  final List times;
  final Function refresh;

  EditDialog({
    @required this.day,
    @required this.times,
    @required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 295,
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          brightness:
              CustomTheme.nightTheme ? Brightness.dark : Brightness.light,
        ),
        home: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Day ${day + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: CustomTheme.nightTheme ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < 4; i++)
                    TimePicker(
                      day: day,
                      session: i,
                      initial: times[i],
                      refresh: refresh,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeDisplay extends StatefulWidget {
  final int day, session;
  final String type;
  final Function refresh;

  TimeDisplay({
    @required this.day,
    @required this.session,
    @required this.type,
    @required this.refresh,
  });
  @override
  State<StatefulWidget> createState() {
    return _TimeDisplayState();
  }
}

class _TimeDisplayState extends State<TimeDisplay> {
  int _time([int sessionNumber]) {
    final int _session = sessionNumber ?? widget.session;
    for (var time in values.customTimes)
      if (time['day'] == widget.day && time['session'] == _session)
        return time['time'];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color:
                          CustomTheme.nightTheme ? Colors.white : Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${values.sessionTimes[widget.type][widget.day][widget.session]}\n',
                        style: const TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: 'mins',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                )
              : Text(
                  '${values.sessionTimes[widget.type][widget.day][widget.session]} mins',
                ),
        ),
        onTap: widget.type == 'custom'
            ? () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  builder: (context) => EditDialog(
                    day: widget.day,
                    refresh: widget.refresh,
                    times: [
                      for (var i = 0; i < 4; i++)
                        _time(i) ??
                            values.sessionTimes[widget.type][widget.day][i]
                    ],
                  ),
                )
            : null,
      ),
    );
  }
}

class ByDayView extends StatefulWidget {
  final int day;
  final String type;

  ByDayView({
    @required this.day,
    @required this.type,
  });

  @override
  State<StatefulWidget> createState() {
    return _ByDayViewState();
  }
}

class _ByDayViewState extends State<ByDayView> {
  Key _key = UniqueKey();
  void _refresh() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        key: _key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                'Day ${widget.day + 1}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 16
                          : 12,
                ),
              ),
            ),
          ),
          TimeDisplay(
            day: widget.day,
            session: 0,
            type: widget.type,
            refresh: _refresh,
          ),
          TimeDisplay(
            day: widget.day,
            session: 1,
            type: widget.type,
            refresh: _refresh,
          ),
          TimeDisplay(
            day: widget.day,
            session: 2,
            type: widget.type,
            refresh: _refresh,
          ),
          TimeDisplay(
            day: widget.day,
            session: 3,
            type: widget.type,
            refresh: _refresh,
          ),
        ],
      ),
    );
  }
}
