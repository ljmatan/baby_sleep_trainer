import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/views/main/navigation_bar/button.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -1),
            color: Colors.grey.shade200,
          ),
        ],
      ),
      child: MediaQuery.of(context).orientation == Orientation.portrait
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavBarButton(
                  view: Views.trainer,
                  icon: Icons.nights_stay,
                ),
                NavBarButton(
                  view: Views.activity,
                  icon: Icons.leaderboard,
                ),
                NavBarButton(
                  view: Views.scheduler,
                  icon: Icons.query_builder,
                ),
                NavBarButton(
                  view: Views.help,
                  icon: Icons.help_center,
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: NavBarButton(
                    view: Views.help,
                    icon: Icons.help_center,
                  ),
                ),
                NavBarButton(
                  view: Views.scheduler,
                  icon: Icons.query_builder,
                ),
                NavBarButton(
                  view: Views.activity,
                  icon: Icons.leaderboard,
                ),
                NavBarButton(
                  view: Views.trainer,
                  icon: Icons.nights_stay,
                ),
              ],
            ),
    );
  }
}
