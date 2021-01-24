import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:baby_sleep_scheduler/views/activity/clear_logs/clear_logs_dialog.dart';
import 'package:flutter/material.dart';

class ClearLogsButton extends StatelessWidget {
  final Function refresh;

  ClearLogsButton({@required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: CustomTheme.nightTheme ? Colors.black : Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Clear training activity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.delete_forever),
                ],
              ),
            ),
          ),
        ),
        onTap: Values.sessionActive
            ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                elevation: 0,
                margin: const EdgeInsets.all(8),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'Can\'t clear logs while a session is in progress.',
                )))
            : () async {
                final bool delete = await showDialog(
                  context: context,
                  builder: (context) => ClearLogsDialog(),
                );
                if (delete != null && delete) refresh();
              },
      ),
    );
  }
}
