import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/views/trainer/inactive_view.dart';
import 'package:baby_sleep_scheduler/views/trainer/sleep/sleep_view.dart';
import 'package:flutter/material.dart';

class TrainerView extends StatefulWidget {
  static _TrainerViewState _state;
  static _TrainerViewState get state => _state;

  @override
  State<StatefulWidget> createState() {
    _state = _TrainerViewState();
    return state;
  }
}

class _TrainerViewState extends State<TrainerView>
    with AutomaticKeepAliveClientMixin {
  Key _key = UniqueKey();

  /// Used in case all sleep logs were deleted. Rebuilds only the InactiveView widget,
  /// as it can't be used if sleep session is in progress.
  void refresh() => setState(() => _key = UniqueKey());

  bool _sleepMode;
  void _startSleepMode() => setState(() => _sleepMode = true);
  void _stopSleepMode() => setState(() => _sleepMode = false);

  @override
  void initState() {
    super.initState();
    _sleepMode = Values.sessionActive;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !_sleepMode
        ? InactiveView(_key, startSleepMode: _startSleepMode)
        : SleepView(stopSleepMode: _stopSleepMode);
  }

  @override
  bool get wantKeepAlive => true;
}
