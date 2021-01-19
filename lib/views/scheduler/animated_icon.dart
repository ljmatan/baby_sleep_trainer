import 'package:flutter/material.dart';

class AnimatedSchedulerIcon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedSchedulerIconState();
  }
}

class _AnimatedSchedulerIconState extends State<AnimatedSchedulerIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _animationController
              .reverse()
              .whenComplete(() => _animationController.forward());
      });
    _opacity = Tween<double>(begin: 1, end: 0).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity.value,
      child: Icon(Icons.info),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
