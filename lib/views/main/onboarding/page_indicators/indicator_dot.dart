import 'package:baby_sleep_scheduler/views/main/onboarding/bloc/indicator_controller.dart';
import 'package:flutter/material.dart';

class IndicatorDot extends StatelessWidget {
  final int index;
  final Color color;

  IndicatorDot(this.index, {@required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: StreamBuilder(
        stream: IndicatorController.stream,
        initialData: 0,
        builder: (context, currentIndex) => DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: color),
            color: index == currentIndex.data ? color : Colors.transparent,
          ),
          child: const SizedBox(width: 12, height: 12),
        ),
      ),
    );
  }
}
