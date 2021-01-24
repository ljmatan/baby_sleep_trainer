import 'dart:async';

import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/view_controller/view_controller.dart';
import 'package:baby_sleep_scheduler/views/activity/activity_view.dart';
import 'package:baby_sleep_scheduler/views/help/help_view.dart';
import 'package:baby_sleep_scheduler/views/main/navigation_bar/navigation_bar.dart';
import 'package:baby_sleep_scheduler/views/scheduler/scheduler_view.dart';
import 'package:baby_sleep_scheduler/views/trainer/trainer_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  static final PageController _pageController = PageController();

  static void _goToPage(int page) => _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );

  final StreamSubscription _pageSubscription = View.stream.listen(
    (view) {
      switch (view) {
        case Views.trainer:
          if (_pageController.page.round() != 0) _goToPage(0);
          break;

        case Views.activity:
          if (_pageController.page.round() != 1) _goToPage(1);
          break;

        case Views.scheduler:
          if (_pageController.page.round() != 2) _goToPage(2);
          break;

        case Views.help:
          if (_pageController.page.round() != 3) _goToPage(3);
          break;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const SizedBox.expand(),
          SizedBox(
            width: MediaQuery.of(context).size.width -
                (MediaQuery.of(context).orientation == Orientation.portrait
                    ? 0
                    : 64),
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).orientation == Orientation.portrait
                    ? 64
                    : 0),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                TrainerView(),
                ActivityView(),
                SchedulerView(),
                HelpView(),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).orientation == Orientation.portrait
                ? null
                : 0,
            left: MediaQuery.of(context).orientation == Orientation.portrait
                ? 0
                : null,
            right: 0,
            bottom: 0,
            child: CustomNavigationBar(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageSubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }
}
