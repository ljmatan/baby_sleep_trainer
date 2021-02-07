import 'package:baby_sleep_scheduler/other/overscroll_removed.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/bloc/color_controller.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/bloc/indicator_controller.dart';
import 'package:baby_sleep_scheduler/views/main/onboarding/page_indicators/indicator_dots.dart';
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
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
              ),
              OnboardingPage(
                icon: Icons.leaderboard,
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
              ),
              OnboardingPage(
                icon: Icons.query_builder,
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
              ),
              OnboardingPage(
                icon: Icons.help_center,
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: IndicatorDots(),
              ),
              GestureDetector(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(),
                  ),
                  child: SizedBox(
                    width: 150,
                    height: 44,
                    child: Center(
                      child: Text(
                        'CONTINUE',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () => _pageIndex == 3
                    ? widget.finish()
                    : _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      ),
              ),
            ],
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
