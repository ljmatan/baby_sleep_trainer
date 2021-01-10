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

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacity;
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() => setState(() {}));
    _opacity = Tween<double>(begin: 1, end: -0.2).animate(_animationController);
    _scale = Tween<double>(begin: 1, end: 1.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  bool _firstRun = false;

  Future<void> _changeView() => _animationController.forward().whenComplete(() {
        setState(() => _firstRun = false);
        _animationController.reverse();
      });

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
      body: Transform.scale(
        scale: _scale.value,
        child: Opacity(
          opacity: _opacity.value < 0 ? 0 : _opacity.value,
          child:
              /*_firstRun
              ? OnboardingView(finish: _changeView)
              :*/ // TODO: Update
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Column(
                      children: [
                        Expanded(
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
                        CustomNavigationBar(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
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
                        CustomNavigationBar(),
                      ],
                    ),
        ),
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
