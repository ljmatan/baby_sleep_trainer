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
          const Expanded(flex: 5, child: SizedBox()),
          LabelDisplay(
            '1st check' +
                (MediaQuery.of(context).orientation == Orientation.portrait
                    ? '\nafter'
                    : ''),
          ),
          LabelDisplay(
            '2nd check' +
                (MediaQuery.of(context).orientation == Orientation.portrait
                    ? '\nafter'
                    : ''),
          ),
          LabelDisplay(
            '3rd check' +
                (MediaQuery.of(context).orientation == Orientation.portrait
                    ? '\nafter'
                    : ''),
          ),
          LabelDisplay(
            'following' +
                (MediaQuery.of(context).orientation == Orientation.portrait
                    ? '\nafter'
                    : ''),
          ),
        ],
      ),
    );
  }
}
