import 'package:baby_sleep_scheduler/global/values.dart';
import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'end_session_dialog.dart';
import 'package:flutter/material.dart';

class EndSessionButton extends StatefulWidget {
  final String mode;
  final Function() endSession;

  EndSessionButton({@required this.mode, @required this.endSession});

  @override
  State<StatefulWidget> createState() {
    return _EndSessionButtonState();
  }
}

class _EndSessionButtonState extends State<EndSessionButton> {
  bool _ending = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).backgroundColor,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            height: 48,
            child: Center(
              child: _ending
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  : Text(
                      widget.mode == States.sleeping.label
                          ? 'End Training'
                          : 'Cancel Session',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ),
        onTap: () async {
          final bool ending = await showDialog(
            context: context,
            barrierColor: CustomTheme.nightTheme
                ? Colors.black87
                : Colors.white.withOpacity(0.87),
            builder: (context) => EndSessionDialog(
              endSession: widget.endSession,
              unsuccessful: widget.mode == States.sleeping.label ? null : true,
            ),
          );
          if (ending != null && ending) setState(() => _ending = true);
        },
      ),
    );
  }
}
