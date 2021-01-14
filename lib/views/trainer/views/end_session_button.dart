import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final Function onTap;

  SelectionButton({@required this.label, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 48,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

class NoteDialog extends StatefulWidget {
  final Function setEnding;
  final Function endSession;

  NoteDialog({@required this.setEnding, @required this.endSession});

  @override
  State<StatefulWidget> createState() {
    return _NoteDialogState();
  }
}

class _NoteDialogState extends State<NoteDialog> {
  bool _unsuccessful = false;

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_unsuccessful) {
      return WillPopScope(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  minLines: 2,
                  maxLines: 2,
                  autofocus: true,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Add a note',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Back',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _unsuccessful = false);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Submit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.setEnding(true);
                        widget.endSession(
                          null,
                          'Unsuccessful',
                          _textController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onWillPop: () async {
          _textController.dispose();
          return true;
        },
      );
    } else
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectionButton(
            label: 'Done Sleeping',
            onTap: () async {
              widget.setEnding(true);
              Navigator.pop(context);
              await widget.endSession();
            },
          ),
          Divider(),
          SelectionButton(
            label: 'Unsuccessful',
            onTap: () => setState(
              () => _unsuccessful = true,
            ),
          ),
          Divider(),
          SelectionButton(
            label: 'Cancel',
            onTap: () => Navigator.pop(context),
          ),
        ],
      );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

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
    return GestureDetector(
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
          builder: (context) => Center(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: NoteDialog(
                      setEnding: _setEnding,
                      endSession: widget.endSession,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (_ending) setState(() => null);
      },
    );
  }
}
