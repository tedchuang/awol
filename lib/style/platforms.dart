import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }
}

final ThemeData _androidTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.brown,
  accentColor: Colors.teal,
  buttonColor: Colors.teal,
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
);

final ThemeData _iOSTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  accentColor: Colors.blue,
  buttonColor: Colors.blue,
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
);

ThemeData getAdaptiveThemeData(context) {
  return Platform.isIOS ? _iOSTheme : _androidTheme;
}
