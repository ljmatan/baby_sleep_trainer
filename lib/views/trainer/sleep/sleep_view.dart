import 'dart:async';
import 'dart:math' as math;

import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/logic/notifications/notifications.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:baby_sleep_scheduler/views/activity/activity_view.dart';
import 'timer/center_timer.dart';
import 'timer/timer.dart';
import 'actions/actions.dart';
import 'bloc/sleep_session.dart';
import 'package:flutter/material.dart';

class SleepView extends StatefulWidget {
  final Function stopSleepMode;

  SleepView({@required this.stopSleepMode});

  @override
  State<StatefulWidget> createState() {
    return _SleepViewState();
  }
}

class _SleepViewState extends State<SleepView> with WidgetsBindingObserver {
  DateTime _sleepStart;
  int _day;

  bool _paused = false;
  bool _countdown = false;
  DateTime _pauseStart;
  int _sessionNumber;
  int _cryTime;
  int _awakeTime;

  int _totalTimeInSeconds = 0;
  int _minutes = 0;
  int _hours = 0;
  int _deductable;

  bool _cryTimeOver = false;

  Future<void> _endSession([
    int seconds,
    String type = 'Successful',
    String note = '',
  ]) async {
    if (_paused && seconds != 10800) await _resume(false, true);

    // Update logs
    await DB.db.rawUpdate(
      'UPDATE Logs SET '
      'type = ?, '
      'note = ?, '
      'totalTime = ?, '
      'cryTime = ?, '
      'awakeTime = ? '
      'WHERE id = ?',
      [
        seconds != null ? 'Unsuccessful' : type,
        seconds != null ? 'Inactive session' : note,
        seconds != null
            ? seconds == 43200
                ? 43200
                : _totalTimeInSeconds - 10800
            : _totalTimeInSeconds,
        _cryTime,
        seconds == 10800 ? 10800 : _awakeTime,
        Prefs.instance.getInt(Cached.trainingID.label),
      ],
    );

    // Remove values from cache memory
    for (var key in Prefs.instance.getKeys())
      if (key != Cached.trainingStarted.label &&
          key != Cached.day.label &&
          key != Cached.sessionType.label) await Prefs.instance.remove(key);

    if (type == 'Successful' && seconds == null)
      await Values.setDay(Values.currentDay + 1);
    else {
      final List<Map> _logs =
          await DB.db.rawQuery('SELECT * FROM Logs WHERE type IS NOT NULL');

      int _highestRecorded = 0;
      for (var log in _logs)
        if (log['day'] > _highestRecorded) _highestRecorded = log['day'];

      if (Values.currentDay == _highestRecorded)
        await Values.setDay(_highestRecorded + 1);
    }

    // Set value for the next session
    SleepSession.setSessionState(States.playing);

    // Return to trainer screen
    widget.stopSleepMode(seconds != null);

    // If activity view is active, refresh the log list
    ActivityView.state?.refresh();

    // Cancel any currently scheduled notification
    await Notifications.clear();
  }

  void _setTime() {
    // Current timer time
    _totalTimeInSeconds = _countdown
        ? ((sessionTimes[Prefs.instance.getString(Cached.sessionType.label) ??
                            'regular']
                        [Values.currentDay > 6 ? 6 : Values.currentDay]
                    [_sessionNumber <= 3 ? _sessionNumber : 3]) *
                60 -
            DateTime.now().difference(_pauseStart).inSeconds)
        : _paused && !_countdown
            ? DateTime.now().difference(_pauseStart).inSeconds + _awakeTime
            : DateTime.now().difference(_sleepStart).inSeconds - _deductable;
    if (_totalTimeInSeconds < 0) {
      _totalTimeInSeconds = 0;
      if (!_cryTimeOver && SleepSession.data == States.crying.label)
        setState(() => _cryTimeOver = true);
    }

    _hours =
        ((_totalTimeInSeconds - (_totalTimeInSeconds % 3600)) / 3600).round();
    final int _minutesRemainder = _totalTimeInSeconds - _hours * 3600;
    _minutes = ((_minutesRemainder - (_minutesRemainder % 60)) / 60).round();

    if (_hours >= 3 && _paused && SleepSession.data == States.playing.label)
      _endSession(10800);
    else if (_hours >= 12 && !_paused) _endSession(43200);
  }

  final StreamController _timeController = StreamController.broadcast();

  Timer _timer;

  void _setTimer() => _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (_countdown && _totalTimeInSeconds >= 0 || !_countdown) {
            _setTime();
            _timeController.add(_totalTimeInSeconds);
          }
        },
      );

  @override
  void initState() {
    super.initState();

    // Add app state change observer
    WidgetsBinding.instance.addObserver(this);

    // Init stream controller
    SleepSession.init();

    // Get sleep start time if session is in progress
    _sleepStart = Values.sleepStart;

    // Get current day
    _day = Values.currentDay;

    // Whether the session is paused
    final bool paused = Prefs.instance.getBool(Cached.paused.label);
    if (paused != null && paused) {
      // Adjust view
      _paused = true;
      // Get pause start time
      _pauseStart = DateTime.parse(
        Prefs.instance.getString(Cached.pauseStart.label),
      );
      // Get pause reason (crying or playing)
      final String pauseReason =
          Prefs.instance.getString(Cached.pauseReason.label);
      // Adjust view
      if (pauseReason == States.playing.label)
        SleepSession.setSessionState(States.playing);
      else
        SleepSession.setSessionState(States.crying);
    }

    // Number of seconds to deduct from total sleep time
    _deductable = Prefs.instance.getInt(Cached.deductable.label) ?? 0;
    // How many times the baby woke up
    _sessionNumber = Prefs.instance.getInt(Cached.sessionNumber.label) ?? 0;
    // How much time baby spent crying in this session
    _cryTime = Prefs.instance.getInt(Cached.cryTime.label) ?? 0;
    // How much time baby spent playing in this session
    _awakeTime = Prefs.instance.getInt(Cached.awakeTime.label) ?? 0;
    // Whether the session is in countdown/crying mode
    _countdown = Prefs.instance.getBool(Cached.countdown.label) ?? false;

    // Set variables
    _setTime();
    // Start timer
    _setTimer();

    // If session had just started, make all of the necessary adjustments
    if (paused == null) _pause(States.playing);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setTime();
      if (_totalTimeInSeconds >= 10800 &&
          _paused &&
          SleepSession.data == States.playing.label)
        _endSession(10800);
      else if (_totalTimeInSeconds >= 43200 && !_paused) _endSession(43200);
    }
  }

  Future<void> _pause(States reason) async {
    if (_paused) await _resume(true);

    // Set pause start time
    final DateTime startTime = DateTime.now();

    // Cancel timer until the new values are set
    _timer.cancel();

    if (reason == States.crying) {
      _countdown = true;
      _minutes = sessionTimes[
              Prefs.instance.getString(Cached.sessionType.label) ??
                  'regular'][Values.currentDay > 6 ? 6 : Values.currentDay]
          [_sessionNumber <= 3 ? _sessionNumber : 3];
      _totalTimeInSeconds = _minutes * 60;
      await Prefs.instance.setBool(Cached.countdown.label, true);
    } else {
      _totalTimeInSeconds = _awakeTime;
    }

    // Set paused variable
    _paused = true;

    // Cache the paused variable
    await Prefs.instance.setBool(Cached.paused.label, _paused);

    // Cache pause start time
    await Prefs.instance
        .setString(Cached.pauseStart.label, startTime.toIso8601String());

    // Cache pause reason
    await Prefs.instance.setString(Cached.pauseReason.label, reason.label);

    // Set variables
    _pauseStart = startTime;
    SleepSession.change(reason.label);

    // Start timer again
    _setTimer();

    // Update view
    _setTime();
    _timeController.add(_totalTimeInSeconds);

    // Schedule a notification in case the baby started crying
    if (reason == States.crying) await Notifications.scheduleNotification();
  }

  Future<void> _resume([bool stillPaused = false, bool end = false]) async {
    // Cancel timer until the new values are set
    _timer.cancel();

    // Set total time session was paused
    final int _pauseTimeInSeconds = DateTime.now()
        .difference(
            DateTime.parse(Prefs.instance.getString(Cached.pauseStart.label)))
        .inSeconds;

    // Set cry or sleep time variables and cache them
    if (SleepSession.data == States.crying.label) {
      final int thisSessionTime = sessionTimes[
              Prefs.instance.getString(Cached.sessionType.label) ??
                  'regular'][Values.currentDay > 6 ? 6 : Values.currentDay]
          [_sessionNumber <= 3 ? _sessionNumber : 3];
      _cryTime +=
          _cryTimeOver ? (thisSessionTime * 60).round() : _pauseTimeInSeconds;
      await Prefs.instance.setInt(Cached.cryTime.label, _cryTime);
    } else {
      _awakeTime += _pauseTimeInSeconds;
      await Prefs.instance.setInt(Cached.awakeTime.label, _awakeTime);
    }

    final bool _isCryTimeOver = _cryTimeOver ? true : false;

    _cryTimeOver = false;

    // Update the session number if baby started crying
    if (SleepSession.data == States.crying.label) {
      await Prefs.instance.setBool(Cached.countdown.label, false);
      _countdown = false;
      if (_isCryTimeOver) {
        setState(() => _sessionNumber++);
        await Prefs.instance.setInt(Cached.sessionNumber.label, _sessionNumber);
      }
    }

    // Update deductable time
    _deductable += _pauseTimeInSeconds;

    // If the trainer is no longer paused i.e., state is not crying or awake
    if (!stillPaused) {
      _paused = false;
      _setTime();
      if (!end) _timeController.add(_totalTimeInSeconds);
    }

    // Set cached values
    await Prefs.instance.setInt(Cached.deductable.label, _deductable);
    if (!stillPaused) {
      await Prefs.instance.setBool(Cached.paused.label, false);
      await Prefs.instance.remove(Cached.pauseStart.label);
      await Prefs.instance.remove(Cached.pauseReason.label);
    }

    if (!stillPaused) {
      // Set the "Sleeping state"
      if (!end) SleepSession.change(States.sleeping.label);
      // Start timer
      _setTimer();
    }

    // Cancel any currently scheduled notification
    await Notifications.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              16, MediaQuery.of(context).padding.top + 16, 16, 0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Theme.of(context).backgroundColor,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder(
                              stream: SleepSession.stream,
                              initialData: SleepSession.data,
                              builder: (context, mode) => RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Baby is\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: mode.data[0].toUpperCase() +
                                          mode.data.substring(1),
                                      style: TextStyle(
                                        color: CustomTheme.nightTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'Day ${_day + 1} • Session ${_sessionNumber + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? StreamBuilder(
                              stream: SleepSession.stream,
                              initialData: SleepSession.data,
                              builder: (context, mode) => Image.asset(
                                'assets/images/' +
                                    mode.data.toLowerCase() +
                                    '.png',
                                height: 100,
                              ),
                            )
                          : SessionTimer(
                              stream: _timeController.stream,
                              initial: _totalTimeInSeconds,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        StreamBuilder(
          stream: SleepSession.stream,
          initialData: SleepSession.data,
          builder: (context, mode) => mode.data == States.crying.label
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    'In order for the training to be successful, '
                    'please wait until the time below has passed before checking on your baby.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade300, fontSize: 15),
                  ),
                )
              : const SizedBox(),
        ),
        if (MediaQuery.of(context).orientation == Orientation.portrait)
          CenterTimer(
            stream: _timeController.stream,
            initial: _totalTimeInSeconds,
            cryTimeOver: _cryTimeOver,
          ),
        StreamBuilder(
          stream: SleepSession.stream,
          initialData: SleepSession.data,
          builder: (context, mode) => Column(
            children: [
              if (mode.data == States.crying.label)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Builder(
                    builder: (context) {
                      final int messageIndex = math.Random().nextInt(4);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _cryTimeOver
                              ? 'Try to calm your baby. The baby may cry louder, but that is ok. ' +
                                  'Come back in about a minute and proceed by tapping the button below.'
                              : messages[messageIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomTheme.nightTheme
                                ? Colors.grey
                                : Color(0xff14343a),
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SleepActions(
                pause: _pause,
                resume: _resume,
                endSession: _endSession,
                mode: mode.data,
                cryTimeOver: _cryTimeOver,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _timeController.close();
    SleepSession.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
