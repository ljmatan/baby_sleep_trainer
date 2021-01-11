import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/logic/notifications/notifications.dart';
import 'package:baby_sleep_scheduler/views/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'global/values.dart' as values;

void main() async {
  // Required by framework
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialise notification plugin
  await Notifications.init();

  // Initialise SQLite database used for log storage
  await DB.init();

  // Initialise session / cache storage
  await Prefs.init();

  await values.initSessionTimes();

  runApp(MyApp());

  // Set status and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Oswald',
        accentColor: Colors.white,
        primaryColor: Color(0xff9d8bc4),
      ),
      home: MainView(),
    );
  }
}
