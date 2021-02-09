import 'package:baby_sleep_scheduler/views/help/alarm_option.dart';
import 'package:baby_sleep_scheduler/views/help/night_theme_option.dart';
import 'package:baby_sleep_scheduler/views/help/q_and_a.dart';
import 'package:baby_sleep_scheduler/views/main/main_view.dart';
import 'package:flutter/material.dart';

class HelpView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelpViewState();
  }
}

class _HelpViewState extends State<HelpView> {
  Key _key = UniqueKey();
  void _refresh() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: Text(
            'Settings',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const Divider(height: 0, indent: 16, endIndent: 16),
        NightThemeOption(_refresh),
        AlarmOption(),
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 64,
            child: Center(
              child: GestureDetector(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(26, 12, 26, 12),
                    child: Text(
                      'TUTORIAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onTap: () => MainView.state.displayTutorial(),
              ),
            ),
          ),
        ),
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16, top: 20),
          child: Text(
            'FAQ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const Divider(height: 0, indent: 16, endIndent: 16),
        QandA(_key),
      ],
    );
  }
}
