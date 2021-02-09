import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/view_controller/view_controller.dart';
import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final Views view;

  NavigationButton({@required this.icon, @required this.view});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: StreamBuilder(
        stream: View.stream,
        initialData: Views.activity,
        builder: (context, active) => Column(
          children: [
            Icon(
              icon,
              color: view.label == active.data.label
                  ? Colors.pink.shade300
                  : Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                view.label,
                style: TextStyle(
                  fontSize: 10,
                  color: view.label == active.data.label
                      ? Colors.pink.shade300
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => View.change(view),
    );
  }
}
