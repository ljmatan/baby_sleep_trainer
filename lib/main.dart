import 'dart:io' as io show Platform;

import 'logic/background_services/bg_services.dart';
import 'logic/cache/db.dart';
import 'logic/cache/prefs.dart';
import 'logic/notifications/notifications.dart';
import 'logic/vibration/vibration.dart';
import 'theme/theme.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'global/values.dart' as values;
import 'views/main/main_view.dart';

void main() async {
  // Required by framework
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise notification plugin
  await Notifications.init();

  // Initialise SQLite database used for log storage
  await DB.init();

  // Initialise session / cache storage
  await Prefs.init();

  // Get custom session times
  await values.initSessionTimes();

  if (io.Platform.isAndroid) {
    // Initialise vibration services
    await VibrationServices.init();
    // Initialise background services
    await BackgroundServices.init();
  }

  // Set custom theme data
  CustomTheme.init();

  runApp(MyApp());

  // Keep screen turned on while the user is in the app
  Wakelock.enable();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CustomTheme.stream,
      builder: (context, nightTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.themeData,
        home: MainView(),
      ),
    );
  }
}
