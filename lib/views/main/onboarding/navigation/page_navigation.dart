import 'package:baby_sleep_scheduler/views/main/onboarding/navigation/page_indicators/indicator_dots.dart';
import 'package:flutter/material.dart';

class PageNavigation extends StatefulWidget {
  final PageController pageController;
  final Function onboardingFinished;
  final int page;
  final Color color;

  PageNavigation(
    Key key, {
    @required this.pageController,
    @required this.onboardingFinished,
    @required this.page,
    @required this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageNavigationState();
  }
}

class PageNavigationState extends State<PageNavigation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() => setState(() {}));
    _offset = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  bool _lastStep = false;

  void lastStep() async {
    await _animationController.forward();
    _lastStep = true;
    _animationController.reverse();
  }

  void goBack() async {
    await _animationController.forward();
    _lastStep = false;
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0, _lastStep ? _offset.value : 100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(26, 10, 26, 10),
                      child: Center(
                        child: Text(
                          'GOT IT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () => widget.onboardingFinished(),
                ),
              ],
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, _lastStep ? 100 : _offset.value),
          child: Stack(
            children: [
              SizedBox(height: 48, child: IndicatorDots(widget.page)),
              Positioned(
                right: 16,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: widget.color,
                        size: 20,
                      ),
                    ),
                  ),
                  onTap: () => widget.pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  ),
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
    _animationController.dispose();
    super.dispose();
  }
}
