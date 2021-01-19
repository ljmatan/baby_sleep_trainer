import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/views/trainer/inactive_view.dart';
import 'package:baby_sleep_scheduler/views/trainer/views/sleep_view.dart';
import 'package:flutter/material.dart';

class TrainerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrainerViewState();
  }
}

class _TrainerViewState extends State<TrainerView>
    with AutomaticKeepAliveClientMixin {
  bool _sleepMode;
  void _startSleepMode() => setState(() => _sleepMode = true);
  void _stopSleepMode() => setState(() => _sleepMode = false);

  @override
  void initState() {
    super.initState();
    _sleepMode = Prefs.instance.getBool(States.sleeping.label) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !_sleepMode
        ? InactiveView(startSleepMode: _startSleepMode)
        : SleepView(stopSleepMode: _stopSleepMode);
  }

  @override
  bool get wantKeepAlive => true;
}
