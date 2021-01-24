import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/views/trainer/trainer_view.dart';
import 'package:flutter/material.dart';

class ClearLogsDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClearLogsDialogState();
  }
}

class _ClearLogsDialogState extends State<ClearLogsDialog> {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _deleting
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Delete all recorded activity? This action is irreversible.',
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlatButton(
                            color: Theme.of(context).primaryColor,
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              setState(() => _deleting = true);
                              for (var key in Prefs.instance.getKeys())
                                await Prefs.instance.remove(key);
                              await DB.db.rawDelete(
                                'DELETE FROM Logs WHERE type IS NOT NULL',
                              );
                              Navigator.pop(context, true);
                              TrainerView.state.refresh();
                            },
                          ),
                          const SizedBox(width: 12),
                          FlatButton(
                            color: Theme.of(context).primaryColor,
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
