import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'end_session_dialog.dart';
import 'package:flutter/material.dart';

class EndSessionButton extends StatefulWidget {
  final Function() endSession;

  EndSessionButton({@required this.endSession});

  @override
  State<StatefulWidget> createState() {
    return _EndSessionButtonState();
  }
}

class _EndSessionButtonState extends State<EndSessionButton> {
  bool _ending = false;

  void _setEnding(bool) => _ending = bool;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: CustomTheme.nightTheme ? Colors.black : Colors.white,
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
                  : Text('End Training'),
            ),
          ),
        ),
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) => EndSessionDialog(
              setEnding: _setEnding,
              endSession: widget.endSession,
            ),
          );
          if (_ending) setState(() => null);
        },
      ),
    );
  }
}
