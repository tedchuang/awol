import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awol/scoped.dart';

import './pages/home_page.dart';
import './pages/login_page.dart';
import './style/custom_route.dart';
import './style/platforms.dart';
import './utils/service_locator.dart';

void main() {
  initializeDateFormatting().then((_) {
    setupLocator();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    model.autoAuthenticate();
    model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        color: Colors.brown,
        debugShowCheckedModeBanner: false,
        title: 'swan',
        theme: getAdaptiveThemeData(context),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? LoginScreen(model) : HomePage(model, 0),
        },
// ----------------------------------------------------------------------------        
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return CupertinoPageRoute<bool>(
              builder: (BuildContext context) => LoginScreen(model),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'vacation') {
            final String vacationId = pathElements[2];
            return CustomRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? LoginScreen(model) : HomePage(model, int.parse(vacationId)),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return CupertinoPageRoute(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? LoginScreen(model) : HomePage(model, 0));
        },
      ),
    );
  }
}
