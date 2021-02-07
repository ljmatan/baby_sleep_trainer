import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';

enum Views { trainer, activity, scheduler, help }

extension ViewsExtension on Views {
  String get label {
    switch (this) {
      case Views.trainer:
        return 'Trainer';
      case Views.activity:
        return 'Activity';
      case Views.scheduler:
        return 'Editor';
      case Views.help:
        return 'Help & FAQ';
      default:
        return null;
    }
  }
}

enum States { sleeping, crying, playing }

extension StatesExtension on States {
  String get label {
    switch (this) {
      case States.sleeping:
        return 'sleeping';
      case States.crying:
        return 'crying';
      case States.playing:
        return 'awake';
      default:
        return null;
    }
  }
}

enum Cached {
  trainingStarted,
  day,
  trainingID,
  sleepStarted,
  paused,
  countdown,
  sessionNumber,
  sessionType,
  cryTime,
  awakeTime,
  pauseStart,
  pauseReason,
  deductable,
}

extension CachedExtension on Cached {
  String get label {
    switch (this) {
      case Cached.trainingStarted:
        return 'trainingStarted';
      case Cached.day:
        return 'day';
      case Cached.trainingID:
        return 'trainingID';
      case Cached.sleepStarted:
        return 'sleepStarted';
      case Cached.paused:
        return 'paused';
      case Cached.countdown:
        return 'countdown';
      case Cached.sessionNumber:
        return 'sessionNumber';
      case Cached.sessionType:
        return 'sessionType';
      case Cached.cryTime:
        return 'cryTime';
      case Cached.awakeTime:
        return 'awakeTime';
      case Cached.pauseStart:
        return 'pauseStart';
      case Cached.pauseReason:
        return 'pauseReason';
      case Cached.deductable:
        return 'deductable';
      default:
        return null;
    }
  }
}

final Map messages = const {
  0: 'You can do it! It is hard, but your baby is learning how to self-soothe.',
  1: 'It\'s very difficult to hear the cries, but soon your baby will be sleeping better throughout the night.',
  2: 'This will be good for both you and your baby. Hang in there.',
  3: 'You are doing so well. It\'s just a few more nights.',
};

Map sessionTimes = {
  'regular': const {
    0: {0: 3, 1: 5, 2: 10, 3: 10},
    1: {0: 5, 1: 10, 2: 12, 3: 12},
    2: {0: 10, 1: 12, 2: 15, 3: 15},
    3: {0: 12, 1: 15, 2: 17, 3: 17},
    4: {0: 15, 1: 17, 2: 20, 3: 20},
    5: {0: 17, 1: 20, 2: 25, 3: 25},
    6: {0: 20, 1: 25, 2: 30, 3: 30},
  },
  'mild': const {
    0: {0: 1, 1: 3, 2: 5, 3: 5},
    1: {0: 3, 1: 5, 2: 10, 3: 10},
    2: {0: 5, 1: 10, 2: 12, 3: 12},
    3: {0: 10, 1: 12, 2: 15, 3: 15},
    4: {0: 12, 1: 15, 2: 17, 3: 17},
    5: {0: 15, 1: 17, 2: 20, 3: 20},
    6: {0: 15, 1: 17, 2: 20, 3: 20},
  },
  'custom': {
    0: {0: 3, 1: 5, 2: 10, 3: 10},
    1: {0: 5, 1: 10, 2: 12, 3: 12},
    2: {0: 10, 1: 12, 2: 15, 3: 15},
    3: {0: 12, 1: 15, 2: 17, 3: 17},
    4: {0: 15, 1: 17, 2: 20, 3: 20},
    5: {0: 17, 1: 20, 2: 25, 3: 25},
    6: {0: 20, 1: 25, 2: 30, 3: 30},
  },
};

List<Map<String, dynamic>> customTimes;

Future<void> initSessionTimes() async {
  final _temp = sessionTimes['custom'];

  customTimes = await DB.db.rawQuery('SELECT * FROM CustomTimes');

  for (MapEntry<int, Map<int, int>> day in sessionTimes['custom'].entries)
    for (var entry in sessionTimes['custom'][day.key].entries)
      for (var time in customTimes)
        if (day.key == time['day'] && entry.key == time['session'])
          _temp[day.key][entry.key] = time['time'];

  sessionTimes['custom'] = _temp;
}

abstract class Values {
  static bool get onboarded => Prefs.instance.getBool('onboarded') ?? false;
  static Future<void> userOnboarded() async =>
      await Prefs.instance.setBool('onboarded', true);

  static bool get trainingStarted =>
      Prefs.instance.getBool(Cached.trainingStarted.label);
  static Future<void> setTrainingStarted() async =>
      await Prefs.instance.setBool(Cached.trainingStarted.label, true);

  static bool get sessionActive =>
      Prefs.instance.getBool(States.sleeping.label) ?? false;

  static DateTime get sleepStart =>
      DateTime.parse(Prefs.instance.getString(Cached.sleepStarted.label));

  static int get currentDay => Prefs.instance.getInt(Cached.day.label);
  static Future<void> setDay(int day) async =>
      await Prefs.instance.setInt(Cached.day.label, day);

  static int get trainingID => Prefs.instance.getInt(Cached.trainingID.label);
  static Future<void> setTrainingID(int id) async =>
      await Prefs.instance.setInt(Cached.trainingID.label, id);

  static bool get nightTheme => Prefs.instance.getBool('nightTheme') ?? false;
  static Future<void> setNightTheme(bool value) async =>
      await Prefs.instance.setBool('nightTheme', value);

  static bool get alarms => Prefs.instance.getBool('alarms') ?? true;
  static Future<void> setAlarms(bool value) async =>
      await Prefs.instance.setBool('alarms', value);
}
