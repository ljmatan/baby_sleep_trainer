import 'package:baby_sleep_scheduler/views/activity/summary_graph/controller.dart';
import 'package:flutter/material.dart';

class GraphModeButton extends StatelessWidget {
  final String label, mode;

  GraphModeButton({@required this.label, @required this.mode});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GraphController.stream,
      initialData: 'cryTime',
      builder: (context, currentMode) => TextButton(
        style: ButtonStyle(
          overlayColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: currentMode.data == mode ? FontWeight.bold : null,
            color: currentMode.data == mode
                ? Theme.of(context).textTheme.bodyText2.color
                : Colors.grey,
          ),
        ),
        onPressed: () => GraphController.change(mode),
      ),
    );
  }
}

class GraphModeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GraphModeButton(label: 'Crying', mode: 'cryTime'),
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
            child: SizedBox(width: 0.5, height: 24),
          ),
          GraphModeButton(label: 'Awake', mode: 'awakeTime'),
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
            child: SizedBox(width: 0.5, height: 24),
          ),
          GraphModeButton(label: 'Time to Sleep', mode: 'other'),
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
            child: SizedBox(width: 0.5, height: 24),
          ),
          GraphModeButton(label: 'Sleep', mode: 'totalTime'),
        ],
      ),
    );
  }
}
