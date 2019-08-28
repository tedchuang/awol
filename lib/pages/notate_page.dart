import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awol/scoped.dart';

import '../style/platforms.dart';
import '../widgets/duties_builder.dart';

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
    widget.model.fetchDuties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No Duties Found!'));
      if (model.allDuties.length > 0 && !model.isLoading) {
        content = Container(
          child: Duties(widget.showInSnackBar),
          color: Colors.yellow[100],
        );
      } else if (model.isLoading) {
        content = Center(child: AdaptiveProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: model.fetchDuties,
        child: content,
      );
    });
  }
}
