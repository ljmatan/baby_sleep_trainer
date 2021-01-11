import 'dart:async';
import 'dart:math' as math;

import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/logic/notifications/notifications.dart';
import 'package:baby_sleep_scheduler/views/activity/activity_view.dart';
import 'package:baby_sleep_scheduler/views/trainer/views/actions.dart';
import 'package:baby_sleep_scheduler/views/trainer/views/sleep_session.dart';
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

  bool _paused = false;
  bool _countdown = false;
  DateTime _pauseStart;
  int _sessionNumber;
  int _cryTime;
  int _playTime;

  int _totalTimeInSeconds = 0;
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  int _deductable;

  Future<void> _endSession([
    int seconds,
    String type = 'Successful',
    String note = '',
  ]) async {
    if (_paused) await _resume();

    // Update logs
    await DB.db.rawUpdate(
      'UPDATE Logs SET '
      'type = ?, '
      'note = ?, '
      'totalTime = ?, '
      'cryTime = ?, '
      'playTime = ? '
      'WHERE id = ?',
      [
        type,
        note,
        seconds ?? _totalTimeInSeconds,
        _cryTime,
        _playTime,
        Prefs.instance.getInt(Cached.trainingID.label),
      ],
    );

    // Remove values from cache memory
    for (var key in Prefs.instance.getKeys())
      if (key != Cached.sessionNumber.label &&
          key != Cached.trainingStarted.label &&
          key != Cached.day.label) await Prefs.instance.remove(key);

    // Set variables
    SleepSession.setSessionState(States.sleeping);

    // Return to trainer screen
    widget.stopSleepMode();

    // If activity view is active, refresh the log list
    ActivityView.state?.refresh();

    // Cancel any currently scheduled notification
    await Notifications.flutterLocalNotificationsPlugin.cancel(0);
  }

  void _setTime() {
    // Current timer time
    _totalTimeInSeconds = _countdown
        ? ((sessionTimes[Prefs.instance.getString(Cached.sessionType.label) ??
                        'regular'][Prefs.instance.getInt(Cached.day.label)]
                    [_sessionNumber]) *
                60 -
            DateTime.now().difference(_pauseStart).inSeconds)
        : (DateTime.now()
                .difference(_paused ? _pauseStart : _sleepStart)
                .inSeconds -
            (_paused ? 0 : _deductable));
    if (_totalTimeInSeconds < 0) _totalTimeInSeconds = 0;
    _hours =
        ((_totalTimeInSeconds - (_totalTimeInSeconds % 3600)) / 3600).round();
    final int _minutesRemainder = _totalTimeInSeconds - _hours * 3600;
    _minutes = ((_minutesRemainder - (_minutesRemainder % 60)) / 60).round();
    _seconds = (_totalTimeInSeconds - _hours * 3600 - _minutes * 60).round();

    if (_hours >= 12) _endSession(43200);
  }

  final StreamController _timeController = StreamController.broadcast();

  Timer _timer;

  void _setTimer() => _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (_countdown && _totalTimeInSeconds > 0 || !_countdown) {
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
    _sleepStart = DateTime.parse(
      Prefs.instance.getString(Cached.sleepStarted.label),
    );

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
    _playTime = Prefs.instance.getInt(Cached.playTime.label) ?? 0;
    // Whether the session is in countdown/crying mode
    _countdown = Prefs.instance.getBool(Cached.countdown.label) ?? false;

    // Set variables
    _setTime();
    // Start timer
    _setTimer();

    // Determine whether the session has just been started and proceed to "awake timer" if true
    if (Prefs.instance.getBool(Cached.paused.label) == null)
      _pause(States.playing);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setTime();
      if (_totalTimeInSeconds > 43200) _endSession(43200);
    }
  }

  Future<void> _pause(States reason) async {
    if (_paused) await _resume();

    // Set pause start time
    final DateTime startTime = DateTime.now();

    // Cancel timer until the new values are set
    _timer.cancel();

    // Set variables
    _hours = 0;
    _minutes = 0;
    _seconds = 0;

    if (reason == States.crying) {
      _countdown = true;
      _minutes = sessionTimes[
              Prefs.instance.getString(Cached.sessionType.label) ?? 'regular']
          [Prefs.instance.getInt(Cached.day.label)][_sessionNumber];
      _totalTimeInSeconds = _minutes * 60;
      await Prefs.instance.setBool(Cached.countdown.label, true);
    }

    // Update view
    _timeController.add(_totalTimeInSeconds);

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

    // Schedule a notification in case the baby started crying
    if (reason == States.crying) await Notifications.scheduleNotification();
  }

  Future<void> _resume() async {
    // Cancel timer until the new values are set
    _timer.cancel();

    // Update the session number if baby started crying
    if (SleepSession.data == States.crying.label) {
      await Prefs.instance.setBool(Cached.countdown.label, false);
      _countdown = false;
      if (_sessionNumber < 3) {
        _sessionNumber++;
        await Prefs.instance.setInt(Cached.sessionNumber.label, _sessionNumber);
      }
    }

    // Set total time session was paused
    final int _pauseTimeInSeconds = DateTime.now()
        .difference(
            DateTime.parse(Prefs.instance.getString(Cached.pauseStart.label)))
        .inSeconds;

    // Set cry or sleep time variables and cache them
    if (SleepSession.data == States.crying.label) {
      _cryTime += _pauseTimeInSeconds;
      await Prefs.instance.setInt(Cached.cryTime.label, _cryTime);
    } else {
      _playTime += _pauseTimeInSeconds;
      await Prefs.instance.setInt(Cached.playTime.label, _playTime);
    }

    // Set variables
    _deductable += _pauseTimeInSeconds;
    _paused = false;
    _setTime();

    // Update view
    setState(() => null);

    // Set cache values
    await Prefs.instance.setInt(Cached.deductable.label, _deductable);
    await Prefs.instance.setBool(Cached.paused.label, false);
    await Prefs.instance.setString(Cached.pauseStart.label, null);
    await Prefs.instance.setString(Cached.pauseReason.label, null);

    // More variables
    _pauseStart = null;
    SleepSession.change(States.sleeping.label);

    // Start timer
    _setTimer();

    // Cancel any currently scheduled notification
    await Notifications.flutterLocalNotificationsPlugin.cancel(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              16, MediaQuery.of(context).padding.top + 16, 16, 0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    TextSpan(
                                      text: 'baby is\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: mode.data[0].toUpperCase() +
                                          mode.data.substring(1),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'Day 1 • Session ${_sessionNumber + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: SleepSession.stream,
                        initialData: SleepSession.data,
                        builder: (context, mode) => Image.asset(
                          'assets/images/' + mode.data.toLowerCase() + '.png',
                          height: 100,
                        ),
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
                    'In order for the training to be successful, in this session you must wait '
                    '${sessionTimes[Prefs.instance.getString(Cached.sessionType.label) ?? 'regular'][Prefs.instance.getInt(Cached.day.label)][_sessionNumber]}'
                    ' minutes before responding to baby\'s cries. You\'ll receive a notification when this period had passed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade300, fontSize: 13),
                  ),
                )
              : const SizedBox(),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: SleepSession.stream,
                initialData: SleepSession.data,
                builder: (context, mode) => Text(
                  mode.data == States.crying.label
                      ? 'wait for'
                      : mode.data == States.playing.label
                          ? 'awake time'
                          : 'sleep time',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              StreamBuilder(
                stream: _timeController.stream,
                builder: (context, _) => Text(
                  (_hours < 10 ? '0$_hours' : '$_hours') +
                      ':' +
                      (_minutes < 10 ? '0$_minutes' : '$_minutes') +
                      ':' +
                      (_seconds < 10 ? '0$_seconds' : '$_seconds'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
                      final int messageIndex = math.Random().nextInt(6);
                      return Text(
                        messages[messageIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w200,
                          fontSize: 13,
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
