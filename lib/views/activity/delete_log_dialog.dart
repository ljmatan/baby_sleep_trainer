import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:flutter/material.dart';

class DeleteLogDialog extends StatelessWidget {
  final int id;

  DeleteLogDialog({@required this.id});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
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
                  child: Text('Are you sure you want to delete this entry?'),
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
                        await DB.db
                            .rawDelete('DELETE FROM Logs WHERE id = $id');
                        Navigator.pop(context, true);
                      },
                    ),
                    const SizedBox(width: 12),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.pop(context),
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
