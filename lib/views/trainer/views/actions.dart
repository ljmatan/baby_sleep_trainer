import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:baby_sleep_scheduler/views/trainer/views/end_session_button.dart';
import 'package:flutter/material.dart';

class BabyAwakeButton extends StatelessWidget {
  final String label;
  final Function onTap;

  BabyAwakeButton({@required this.label, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CustomTheme.nightTheme ? Colors.black : Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 48,
          child: Center(child: Text(label)),
        ),
      ),
      onTap: onTap,
    );
  }
}

class SleepActions extends StatelessWidget {
  final Function(States) pause;
  final Function resume, endSession;
  final String mode;

  SleepActions({
    @required this.pause,
    @required this.resume,
    @required this.endSession,
    @required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: BabyAwakeButton(
                    label: mode == States.playing.label
                        ? 'Baby Asleep'
                        : 'Baby Awake',
                    onTap: () async {
                      mode == States.playing.label
                          ? await resume()
                          : await pause(States.playing);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: BabyAwakeButton(
                    label: mode == States.crying.label
                        ? 'Baby Asleep'
                        : 'Baby Crying',
                    onTap: () async {
                      mode == States.crying.label
                          ? await resume()
                          : await pause(States.crying);
                    },
                  ),
                ),
              ],
            ),
          ),
          EndSessionButton(endSession: endSession),
        ],
      ),
    );
  }
}
