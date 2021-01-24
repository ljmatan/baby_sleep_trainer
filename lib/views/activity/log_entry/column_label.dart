import 'package:flutter/material.dart';

class ColumnLabel extends StatelessWidget {
  final double leftPadding;
  final int color;
  final String label;

  ColumnLabel({
    @required this.leftPadding,
    @required this.color,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 12, height: 12),
          ),
          Text('  $label'),
        ],
      ),
    );
  }
}
