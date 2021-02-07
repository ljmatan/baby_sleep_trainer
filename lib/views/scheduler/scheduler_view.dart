import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/views/scheduler/by_day_view.dart';
import 'package:baby_sleep_scheduler/views/scheduler/method_controller.dart';
import 'package:baby_sleep_scheduler/views/scheduler/time_label.dart';
import 'package:flutter/material.dart';

class TimesModel {
  final int first, second, third, subsequent;

  TimesModel({
    this.first,
    this.second,
    this.third,
    this.subsequent,
  });
}

class MethodOption extends StatelessWidget {
  final String option, label, initial;
  final String description;

  MethodOption({
    @required this.option,
    @required this.label,
    @required this.initial,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: StreamBuilder(
                stream: MethodController.stream,
                initialData: initial,
                builder: (context, mode) => Row(
                  children: [
                    Text(
                      label + ' ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    if (mode.data == option)
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
            Text(description)
          ],
        ),
      ),
      onTap: () async {
        await Prefs.instance.setString(Cached.sessionType.label, option);
        MethodController.change(option);
        Navigator.pop(context);
      },
    );
  }
}

class Display extends StatefulWidget {
  final String sessionType;
  final List<Map<String, dynamic>> customTimes;

  Display({@required this.sessionType, this.customTimes});

  @override
  State<StatefulWidget> createState() {
    return _DisplayState();
  }
}

class _DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ByDayView(day: 0, type: widget.sessionType),
          const Divider(height: 0, indent: 16, endIndent: 16),
          ByDayView(day: 1, type: widget.sessionType),
          const Divider(height: 0, indent: 16, endIndent: 16),
          ByDayView(day: 2, type: widget.sessionType),
          const Divider(height: 0, indent: 16, endIndent: 16),
          ByDayView(day: 3, type: widget.sessionType),
          const Divider(height: 0, indent: 16, endIndent: 16),
          ByDayView(day: 4, type: widget.sessionType),
          const Divider(height: 0, indent: 16, endIndent: 16),
          ByDayView(day: 5, type: widget.sessionType),
          const Divider(height: 0, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ByDayView(
              day: 6,
              type: widget.sessionType,
            ),
          ),
        ],
      ),
    );
  }
}

class SchedulerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SchedulerViewState();
  }
}

class _SchedulerViewState extends State<SchedulerView> {
  String _sessionType;
  void _setSessionType() => _sessionType =
      Prefs.instance.getString(Cached.sessionType.label) ?? 'regular';

  @override
  void initState() {
    super.initState();
    MethodController.init();
    _setSessionType();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              16, MediaQuery.of(context).padding.top + 16, 16, 14),
          child: GestureDetector(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).backgroundColor,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                      stream: MethodController.stream,
                      initialData: _sessionType,
                      builder: (context, mode) => Text(
                        '${mode.data[0].toUpperCase()}${mode.data.substring(1)} ' +
                            (!mode.data.contains('custom') ? 'Ferber ' : '') +
                            'Method ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Text(
                      'TAP TO CHANGE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              _setSessionType();
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).backgroundColor,
                isScrollControlled: true,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: MethodOption(
                        option: 'regular',
                        initial: _sessionType,
                        label: 'Regular Ferber Method',
                        description:
                            'Standard times recommended as a guide by Dr. Richard Ferber',
                      ),
                    ),
                    Divider(height: 0),
                    MethodOption(
                      option: 'mild',
                      initial: _sessionType,
                      label: 'Mild Ferber Method',
                      description:
                          'Reduced check in times allowing to check on baby sooner for lesser crying ',
                    ),
                    Divider(height: 0),
                    MethodOption(
                      option: 'custom',
                      initial: _sessionType,
                      label: 'Custom Method',
                      description:
                          'Define your own check in times, to suit your needs. Once selected, you can tap on any time in the table and edit it',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        TimeLabel(),
        Divider(indent: 16, endIndent: 16),
        StreamBuilder(
          stream: MethodController.stream,
          initialData: _sessionType,
          builder: (context, mode) => Display(sessionType: mode.data),
        ),
      ],
    );
  }

  @override
  void dispose() {
    MethodController.dispose();
    super.dispose();
  }
}
