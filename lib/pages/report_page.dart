import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awol/scoped.dart';

class ReportPage extends StatefulWidget {
  final MainModel model;
  final Function showInSnackBar;
  ReportPage(this.model, this.showInSnackBar);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No Events Found!'));
      return content;
    });
  }
}
