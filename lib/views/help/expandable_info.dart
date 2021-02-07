import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableInfo extends StatefulWidget {
  final String label, main, further;

  ExpandableInfo({
    @required this.label,
    @required this.main,
    this.further,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExpandableInfoState();
  }
}

class _ExpandableInfoState extends State<ExpandableInfo> {
  List<InlineSpan> _children;

  void _expand() => _children = <InlineSpan>[
        TextSpan(
          text: widget.main,
          style: TextStyle(
            color: CustomTheme.nightTheme ? Colors.white : Colors.black,
          ),
        ),
        TextSpan(
          text: '\n\n' + widget.further,
          style: TextStyle(
            color: CustomTheme.nightTheme ? Colors.white : Colors.black,
          ),
        )
      ];

  @override
  void initState() {
    super.initState();
    _children = <InlineSpan>[
      TextSpan(
        text: widget.main,
        style: TextStyle(
          color: CustomTheme.nightTheme ? Colors.white : Colors.black,
        ),
      ),
      if (widget.further != null)
        TextSpan(
          text: '\n\nSee more',
          style: const TextStyle(
            color: Color(0xff9d8bc4),
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => setState(() => _expand()),
        ),
    ];
  }

  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.label,
        style: TextStyle(
          color: CustomTheme.nightTheme ? Colors.white : Colors.black,
        ),
      ),
      children: [
        Padding(
          key: _key,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: RichText(
            text: TextSpan(children: _children),
          ),
        ),
      ],
    );
  }
}
