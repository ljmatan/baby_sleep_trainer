import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/views/trainer/sleep/actions/end_session_dialog.dart';
import 'baby_state_button.dart';
import 'end_session_button.dart';
import 'package:flutter/material.dart';

class SleepActions extends StatelessWidget {
  final Function(States) pause;
  final Function resume, endSession;
  final String mode;
  final bool cryTimeOver;

  SleepActions({
    @required this.pause,
    @required this.resume,
    @required this.endSession,
    @required this.mode,
    @required this.cryTimeOver,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: BabyStateButton(
                  label: mode == States.playing.label
                      ? 'Baby Asleep'
                      : mode == States.crying.label
                          ? 'Cancel Training'
                          : 'Baby Awake',
                  onTap: () async {
                    mode == States.playing.label
                        ? await resume()
                        : mode == States.crying.label
                            ? await showDialog(
                                context: context,
                                builder: (context) => EndSessionDialog(
                                  endSession: endSession,
                                  unsuccessful: true,
                                ),
                              )
                            : await pause(States.playing);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: BabyStateButton(
                  label: mode == States.crying.label
                      ? 'Checked on baby'
                      : 'Baby Crying',
                  onTap: () async {
                    mode == States.crying.label
                        ? !cryTimeOver
                            ? ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(8),
                                    content: Text(
                                      'You must wait for the crying time to pass before proceeding.',
                                    )))
                            : await pause(States.playing)
                        : await pause(States.crying);
                  },
                ),
              ),
            ],
          ),
          if (mode != States.crying.label)
            EndSessionButton(endSession: endSession),
        ],
      ),
    );
  }
}
