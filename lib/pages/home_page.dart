// import 'dart:async';
// import 'dart:io';

import 'package:flutter/material.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awol/scoped.dart';

import '../utils/circular_navigation.dart';
import '../utils/circular_tab_item.dart';
import './login_page.dart';
import './notate_page.dart';
import './report_page.dart';

class HomePage extends StatefulWidget {
  final MainModel model;
  final int initialPage;
  HomePage(this.model, this.initialPage);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

// ---------------------------------------------------------------------------- State Extention

class _HomePageState extends State<HomePage> {
  int selectedPos = 0;
  String _barTitle = 'Operatives'; // --- match with 1st default tab shown!

  List<String> _titles = [
    'Operatives',
    'Calendar',
  ];

  List<TabItem> tabItems = List.of([
    new TabItem(
      FontAwesomeIcons.users,
      "Duties",
      Color(0xFF993366),
    ),
    new TabItem(
      FontAwesomeIcons.solidCalendarCheck,
      "Events",
      Color(0xFF993366),
    ),
  ]);

  CircularBottomNavigationController _navigationController;

// ---------------------------------------------------------------------------- Init State

  void initState() {
    selectedPos = widget.initialPage;
    _barTitle = _titles[widget.initialPage];
    _navigationController = new CircularBottomNavigationController(selectedPos);
    super.initState();
    this.initDynamicLinks();
  }

  GlobalKey bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    print('Running initDynamicLinks...');

    if (deepLink != null) {
      String _linkParms = deepLink.queryParameters['ix'];
      String _linkPath = deepLink.path + _linkParms;
      Navigator.pushNamed(context, _linkPath);
      print("Linked: $_linkPath");
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      String _linkParms = deepLink.queryParameters['ix'];
      String _linkPath = deepLink.path + _linkParms;

      if (deepLink != null) {
        Navigator.pushNamed(context, _linkPath);
        print("Pushed: $_linkPath");
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

// ---------------------------------------------------------------------------- Snack Bar

  void showInSnackBar(String value, TextAlign align) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: align,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

// ---------------------------------------------------------------------------- The Builder

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      model.devicePlatform();

      double _chin = MediaQuery.of(context).padding.bottom;
      double _navBarHeight = _chin > 16 ? 72 : 60;

      return Scaffold(
        key: _scaffoldKey,
        // backgroundColor: Color(0xFFcc6699),
        appBar: AppBar(
          title: Text(_barTitle),
          backgroundColor: Color(0xFFcc6699),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              child: bodyContainer(),
              padding: EdgeInsets.only(bottom: _navBarHeight),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: bottomNav(_navBarHeight))
          ],
        ),
      );
    });
  }

  Widget bodyContainer() {
    switch (selectedPos) {
      case 0:
        return NotatePage(widget.model, showInSnackBar);
      case 1:
        return ReportPage(widget.model);
      default:
        return LoginScreen(widget.model);
    }
  }

  Widget bottomNav(double bottomNavBarHeight) {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      iconsSize: 22.0,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Color(0xFFffccff),
      normalIconColor: Color(0xFF993366),
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
          _barTitle = _titles[selectedPos];
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
