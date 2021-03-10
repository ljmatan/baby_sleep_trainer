import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
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
  void _stopSleepMode([bool autoEnded = false]) {
    setState(() => _sleepMode = false);
    if (autoEnded)
      showDialog(
        context: context,
        barrierColor: CustomTheme.nightTheme
            ? Colors.black87
            : Colors.white.withOpacity(0.87),
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your session ended automatically due to inactivity.',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: FlatButton(
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }

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
