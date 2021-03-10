/// File looks like this because of some issue with the framework

import 'package:baby_sleep_scheduler/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableInfo extends StatefulWidget {
  final String label, main, further;
  final List<String> points;

  ExpandableInfo({
    @required this.label,
    this.main,
    this.points,
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
            fontFamily: 'Oswald',
            color: CustomTheme.nightTheme ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        TextSpan(
          text: '\n\n' + widget.further,
          style: TextStyle(
            fontFamily: 'Oswald',
            color: CustomTheme.nightTheme ? Colors.white : Colors.black,
            fontSize: 14,
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
          fontFamily: 'Oswald',
          fontSize: 14,
          color: CustomTheme.nightTheme ? Colors.white : Colors.black,
        ),
      ),
      if (widget.further != null)
        TextSpan(
          text: '\n\nSee more',
          style: const TextStyle(
            fontFamily: 'Oswald',
            color: Color(0xff9d8bc4),
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
          fontSize: 16,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.w500,
          color: CustomTheme.nightTheme ? Colors.white : Colors.black,
        ),
      ),
      children: widget.points == null
          ? [
              Padding(
                key: _key,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: RichText(
                  text: TextSpan(
                    children: _children,
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ]
          : [
              if (widget.main != null)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 12),
                    child: Text(
                      widget.main,
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              for (int i = 0; i < widget.points.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 14,
                      color:
                          CustomTheme.nightTheme ? Colors.white : Colors.black,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text(
                              '${i + 1}.',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.points[i],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.further != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Text(
                    widget.further,
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
    );
  }
}
