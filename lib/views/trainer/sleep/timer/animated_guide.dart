import 'package:flutter/material.dart';

class AnimatedGuide extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedGuideState();
  }
}

class _AnimatedGuideState extends State<AnimatedGuide>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          _animationController
              .reverse()
              .whenComplete(() => _animationController.forward());
      });
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: Text(
        'Check on your baby!',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
