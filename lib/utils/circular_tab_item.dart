import 'package:flutter/material.dart';

class TabItem {
  IconData icon;
  String title;
  Color circleColor;
  TextStyle labelStyle;

  TabItem(this.icon, this.title, this.circleColor,
      {this.labelStyle = const TextStyle(
          color: Color(0xFFffffff), fontWeight: FontWeight.bold)}); // F0E68C
}

// https://github.com/imaNNeoFighT/circular_bottom_navigation/tree/master/lib
