import 'package:flutter/material.dart';

class LabelDisplay extends StatelessWidget {
  final String label;

  LabelDisplay(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class TimeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 5, child: SizedBox()),
          LabelDisplay('1st check\nafter'),
          LabelDisplay('2nd check\nafter'),
          LabelDisplay('3rd check\nafter'),
          LabelDisplay('following\nchecks'),
        ],
      ),
    );
  }
}
