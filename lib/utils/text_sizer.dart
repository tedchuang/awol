import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

class TextSizer extends StatelessWidget {
  final String daText;
  final Color daColor;
  final double daSize;
  final TextAlign daWay;
  final double daHeight;
  final List<Shadow> daShadows;
  final FontWeight daWeight;
  final int daLines;

  TextSizer(
    this.daText, {
    this.daColor = Colors.black,
    this.daSize = 14.0,
    this.daWay = TextAlign.center,
    this.daHeight = 1.0,
    this.daShadows = const [Shadow()],
    this.daWeight = FontWeight.normal,
    this.daLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    double platSize = Platform.isIOS ? daSize : daSize;
    return AutoSizeText(
      daText ?? '(null)',
      overflow: TextOverflow.fade,
      style: TextStyle(
        color: daColor,
        fontFamily: 'OpenSans',
        fontSize: platSize,
        fontWeight: daWeight,
        height: daHeight,
        shadows: daShadows,
      ),
      textAlign: daWay,
      maxLines: daLines,
    );
  }
}
