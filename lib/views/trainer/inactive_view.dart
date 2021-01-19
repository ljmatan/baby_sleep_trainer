import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:baby_sleep_scheduler/logic/cache/db.dart';

class InactiveView extends StatelessWidget {
  final Function startSleepMode;

  InactiveView({@required this.startSleepMode});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 16 + MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ferber Sleep Trainer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Help your baby learn to sleep better!'),
              ),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'Day 1',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: Text(
                  'Once you\'re ready to start the training, tap the button below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              GestureDetector(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CustomTheme.nightTheme ? Colors.black : Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: const Center(
                      child: Text(
                        'baby placed in bed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
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
                      .difference(DateTime.parse(Prefs.instance
                          .getString(Cached.trainingStarted.label)))
                      .inDays;

                  // Set day value to cache
                  if (cachedDay == null ||
                      cachedDay != null && cachedDay != currentDay) {
                    await Prefs.instance.setInt(Cached.day.label,
                        cachedDay == null ? currentDay : _finalDayRecorded + 1);
                    await Prefs.instance.setString(Cached.trainingStarted.label,
                        DateTime.now().toIso8601String());
                    await Prefs.instance.setInt(Cached.sessionNumber.label, 0);
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
                  startSleepMode();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
