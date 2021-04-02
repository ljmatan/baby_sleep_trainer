import 'package:flutter/services.dart';
import 'logic/cache/db.dart';
import 'logic/cache/prefs.dart';
import 'logic/notifications/notifications.dart';
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

  /*if (io.Platform.isAndroid) {
    // Initialise background services
    await BackgroundServices.init();
  }*/

  // Set custom theme data
  CustomTheme.init();

  // Apparently shared prefs don't work so this is a fallback
  final List userInfo = await DB.db.rawQuery('SELECT * FROM UserInfo');
  final bool onboarded = userInfo.isNotEmpty;

  runApp(SleepTrainer(onboarded));

  // Keep screen turned on while the user is in the app
  Wakelock.enable();
}

class SleepTrainer extends StatelessWidget {
  final bool onboarded;

  SleepTrainer(this.onboarded);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CustomTheme.stream,
      builder: (context, nightTheme) => AnnotatedRegion(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.themeData,
          home: MainView(onboarded),
        ),
        value: CustomTheme.nightTheme
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
    );
  }
}
