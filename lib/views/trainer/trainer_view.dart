import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
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
  void _stopSleepMode() => setState(() => _sleepMode = false);

  @override
  void initState() {
    super.initState();
    _sleepMode = Prefs.instance.getBool(States.sleeping.label) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _sleepMode
        ? SleepView(stopSleepMode: _stopSleepMode)
        : Center(
            child: TextButton(
              child: Text('Start baby sleep timer'),
              onPressed: () async {
                // Check for previous training activity and insert a starting date if necessary
                if (Prefs.instance.getString(Cached.trainingStarted.label) ==
                    null)
                  await Prefs.instance.setString(Cached.trainingStarted.label,
                      DateTime.now().toIso8601String());

                final List<Map<String, dynamic>> logs = await DB.db
                    .rawQuery('SELECT * FROM Logs ORDER BY day DESC LIMIT 1');

                int _finalDayRecorded = 0;

                if (logs.isNotEmpty && logs.first['day'] > _finalDayRecorded)
                  _finalDayRecorded = logs.first['day'];

                final int cachedDay = Prefs.instance.getInt(Cached.day.label);

                // Set training day value
                final int currentDay = DateTime.now()
                    .difference(DateTime.parse(
                        Prefs.instance.getString(Cached.trainingStarted.label)))
                    .inDays;

                // Set day value to cache
                if (cachedDay == null ||
                    cachedDay != null && cachedDay != currentDay) {
                  await Prefs.instance.setInt(Cached.day.label,
                      cachedDay == null ? currentDay : _finalDayRecorded + 1);
                  await Prefs.instance.setString(Cached.trainingStarted.label,
                      DateTime.now().toIso8601String());
                }

                // Record day data to and get the entry ID from SQL DB.
                final int id = await DB.db.insert(
                    'Logs', {'day': Prefs.instance.getInt(Cached.day.label)});

                // Record SQL DB ID to cache
                await Prefs.instance.setInt(Cached.trainingID.label, id);

                // Record sleep state to cache
                await Prefs.instance.setBool(States.sleeping.label, true);

                // Record sleep start time to cache
                await Prefs.instance.setString(
                  Cached.sleepStarted.label,
                  DateTime.now().toIso8601String(),
                );

                // Go to timer view
                setState(() => _sleepMode = true);
              },
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
