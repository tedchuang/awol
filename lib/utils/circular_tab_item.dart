import 'package:flutter/material.dart';

class TabItem {
  IconData icon;
  String title;
  Color circleColor;
  TextStyle labelStyle;

  TabItem(this.icon, this.title, this.circleColor,
      {this.labelStyle = const TextStyle(
          color: Color(0xFF993366), fontWeight: FontWeight.bold)});
}

// https://github.com/imaNNeoFighT/circular_bottom_navigation/tree/master/lib
