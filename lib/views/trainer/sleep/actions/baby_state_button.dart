import 'package:flutter/material.dart';

class BabyStateButton extends StatelessWidget {
  final String label;
  final Function onTap;

  BabyStateButton({@required this.label, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 48,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
