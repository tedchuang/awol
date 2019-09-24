import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awol/scoped.dart';

import '../utils/text_sizer.dart';

class LeftDrawer extends StatefulWidget {
  final MainModel model;
  final Function showInSnackBar;
  LeftDrawer(this.model, this.showInSnackBar);

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

void _signOut(BuildContext context, MainModel model) {
  Navigator.of(context).pop();
  model.logout();
  Navigator.pushReplacementNamed(context, "/");
}

class _LeftDrawerState extends State<LeftDrawer> {
  List<Widget> _usefulLinks() {
    final String appVersion = 'Version 0.1.0 - August 31, 2019';
    return <Widget>[
      AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.model.user.userFull ?? 'Useful Links'),
      ),
      ListTile(
        dense: true,
        leading: Icon(FontAwesomeIcons.signOutAlt),
        title: Text('Log Out'),
        onTap: () => _signOut(context, widget.model),
      ),
      Divider(),
      TextSizer(
        appVersion,
        daSize: 12.0,
        daColor: Colors.teal,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Drawer(
          child: Column(
            children: _usefulLinks(),
          ),
        );
      },
    );
  }
}
