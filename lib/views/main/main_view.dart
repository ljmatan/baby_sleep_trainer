import 'dart:async';

import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/logic/cache/db.dart';
import 'package:baby_sleep_scheduler/logic/cache/prefs.dart';
import 'package:baby_sleep_scheduler/logic/view_controller/view_controller.dart';
import 'package:baby_sleep_scheduler/views/activity/activity_view.dart';
import 'package:baby_sleep_scheduler/views/help/help_view.dart';
import 'package:baby_sleep_scheduler/views/main/navigation_bar/navigation_bar.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/onboarding_view.dart';
import 'package:baby_sleep_scheduler/views/scheduler/scheduler_view.dart';
import 'package:baby_sleep_scheduler/views/trainer/trainer_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  final bool onboarded;

  MainView(this.onboarded);

  static _MainViewState _state;
  static _MainViewState get state => _state;

  @override
  State<StatefulWidget> createState() {
    _state = _MainViewState();
    return state;
  }
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacity;
  Animation<double> _scale;

  bool _onboarded = Prefs.instance.getBool('onboarded');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));
    _opacity = Tween<double>(begin: 1, end: -0.2).animate(_animationController);
    _scale = Tween<double>(begin: 1, end: 1.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _onboarded = widget.onboarded;
  }

  static PageController _pageController = PageController();

  bool _replayingTutorial = false;

  void displayTutorial() => _animationController.forward().whenComplete(() {
        setState(() => _onboarded = false);
        _replayingTutorial = true;
        _animationController.reverse();
      });

  void _changeView() => _animationController.forward().whenComplete(() {
        Prefs.instance.setBool('onboarded', true);
        DB.db.insert('userInfo', {'onboarded': 'true'});
        setState(() => _onboarded = true);
        if (_replayingTutorial) {
          _pageController.dispose();
          _pageController = PageController(initialPage: 3);
          _replayingTutorial = false;
        }
        _animationController.reverse();
      });

  static void _goToPage(int page) => _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
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
      backgroundColor:
          _onboarded ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Transform.scale(
        scale: _scale.value,
        child: Opacity(
          opacity: _opacity.value < 0 ? 0 : _opacity.value,
          child: !_onboarded
              ? OnboardingView(finish: _changeView)
              : Stack(
                  children: [
                    const SizedBox.expand(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width -
                          (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 0
                              : 64),
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
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
                      top: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? null
                          : 0,
                      left: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 0
                          : null,
                      right: 0,
                      bottom: 0,
                      child: CustomNavigationBar(),
                    ),
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
