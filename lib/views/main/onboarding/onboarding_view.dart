import 'package:baby_sleep_scheduler/other/overscroll_removed.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/bloc/color_controller.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/bloc/indicator_controller.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/navigation/page_navigation.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  final Function finish;

  OnboardingView({@required this.finish});

  @override
  State<StatefulWidget> createState() {
    return _OnboardingViewState();
  }
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  int _pageIndex = 0;

  bool _lastPage = false;

  final GlobalKey<PageNavigationState> _pageNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    IndicatorController.init();
    ColorController.init();
    _pageController.addListener(
      () {
        if (_pageController.page.round() != _pageIndex) {
          _pageIndex = _pageController.page.round();
          IndicatorController.change(_pageIndex);
          if (_pageIndex == 3 && !_lastPage) {
            _lastPage = true;
            _pageNavigationKey.currentState.lastStep();
          }
          if (_pageIndex != 3 && _lastPage) {
            _lastPage = false;
            _pageNavigationKey.currentState.goBack();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollConfiguration(
          behavior: OverscrollRemovedBehavior(),
          child: PageView(
            controller: _pageController,
            children: [
              OnboardingPage(
                icon: Icons.nights_stay,
                text:
                    'Trainer: Training timer, which guides you through to applying the Ferber method for your child.',
              ),
              OnboardingPage(
                icon: Icons.leaderboard,
                text:
                    'Activity: Activity log, which shows you the statistics of your child\'s sleep training activity till date. '
                    'Notice how your baby\'s crying time is reducing in this screen.',
              ),
              OnboardingPage(
                icon: Icons.query_builder,
                text:
                    'Editor: Select which form of sleep method you would like to follow, and customize the timer to suit your needs.',
              ),
              OnboardingPage(
                icon: Icons.help_center,
                text:
                    'Help & FAQ: Learn about the Ferber method and how to use the app for sleep training your baby. Reading this section will help you prepare well before starting.',
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 6,
          left: 0,
          right: 0,
          child: StreamBuilder(
            stream: ColorController.stream,
            initialData: Theme.of(context).primaryColor,
            builder: (context, color) => PageNavigation(
              _pageNavigationKey,
              pageController: _pageController,
              onboardingFinished: widget.finish,
              page: _pageIndex,
              color: color.data,
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 16 + MediaQuery.of(context).padding.top,
          child: StreamBuilder(
            stream: ColorController.stream,
            initialData: Theme.of(context).primaryColor,
            builder: (context, color) => TextButton(
              child: Text(
                'SKIP',
                style: TextStyle(
                  fontSize: 16,
                  color: color.data,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => widget.finish(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    IndicatorController.dispose();
    ColorController.dispose();
    super.dispose();
  }
}
