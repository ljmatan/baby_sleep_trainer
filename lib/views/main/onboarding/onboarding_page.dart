import 'package:baby_sleep_scheduler/views/main/onboarding/bloc/color_controller.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String text;

  OnboardingPage({@required this.icon, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: StreamBuilder(
            stream: ColorController.stream,
            initialData: Theme.of(context).primaryColor,
            builder: (context, color) => Icon(
              icon,
              color: color.data,
              size: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
