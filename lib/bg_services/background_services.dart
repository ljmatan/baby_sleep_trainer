import 'package:workmanager/workmanager.dart';

abstract class BackgroundServices {
  static void callbackDispatcher() {
    Workmanager.executeTask((task, inputData) {
      return Future.value(true);
    });
  }

  static Future<void> init() async =>
      await Workmanager.initialize(callbackDispatcher);
}
