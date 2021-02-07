import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/view_controller/view_controller.dart';
import 'package:flutter/material.dart';

class NavBarButton extends StatelessWidget {
  final Views view;
  final IconData icon;

  NavBarButton({@required this.view, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 70,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width / 4
            : 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder(
            stream: View.stream,
            initialData: View.initial,
            builder: (context, selected) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: view == selected.data
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    size: 26,
                  ),
                  Text(
                    view.label,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 11
                          : 10,
                      color: view == selected.data
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () => View.change(view),
    );
  }
}
