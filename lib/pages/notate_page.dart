import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awol/scoped.dart';

class NotatePage extends StatefulWidget {
  final MainModel model;
  final Function showInSnackBar;
  NotatePage(this.model, this.showInSnackBar);

  @override
  _NotatePageState createState() => _NotatePageState();
}

class _NotatePageState extends State<NotatePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No Duties Found!'));
      return content;
    });
  }
}
