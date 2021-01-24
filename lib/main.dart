import 'package:baby_sleep_scheduler/logic/background_services/bg_services.dart';
import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/logic/notifications/notifications.dart';
import 'package:baby_sleep_scheduler/logic/vibration/vibration.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:baby_sleep_scheduler/views/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'global/values.dart' as values;

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

  // Initialise vibration services
  await Vibration.init();

  // Initialise background services
  //await BackgroundServices.init();

  CustomTheme.init();

  runApp(MyApp());

  // Set status and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:
          CustomTheme.nightTheme ? Colors.black : Colors.white,
      statusBarIconBrightness:
          CustomTheme.nightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness:
          CustomTheme.nightTheme ? Brightness.light : Brightness.dark,
    ),
  );
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
