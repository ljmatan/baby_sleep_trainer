import 'package:baby_sleep_scheduler/views/main/onboarding/bloc/color_controller.dart';
import 'indicator_dot.dart';
import 'package:flutter/material.dart';

class IndicatorDots extends StatefulWidget {
  final int page;

  IndicatorDots(this.page);

  @override
  State<StatefulWidget> createState() {
    return _IndicatorDotsState();
  }
}

class _IndicatorDotsState extends State<IndicatorDots>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )
      ..repeat()
      ..addListener(() => ColorController.change(
          colors.evaluate(AlwaysStoppedAnimation(_animationController.value))));
  }

  Animatable<Color> colors = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: const Color(0xff9d8bc4),
        end: const Color(0xfff4a9bd),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: const Color(0xfff4a9bd),
        end: const Color(0xff85dbd2),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: const Color(0xff85dbd2),
        end: const Color(0xfffde3a6),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: const Color(0xfffde3a6),
        end: const Color(0xffc8a172),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: const Color(0xffc8a172),
        end: const Color(0xff9d8bc4),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++)
                IndicatorDot(
                  i,
                  widget.page,
                  color: colors.evaluate(
                    AlwaysStoppedAnimation(
                      _animationController.value,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
