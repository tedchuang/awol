import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:awol/scoped.dart';

// ----------------------------------------------------------------------------

class Tick extends StatelessWidget {
  final DecorationImage image;
  Tick({this.image});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: 180.0,
      height: 180.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: image,
      ),
    ));
  }
}

// ----------------------------------------------------------------------------

DecorationImage backgroundImage = new DecorationImage(
  image: new AssetImage('assets/wareHouse.jpeg'),
  fit: BoxFit.cover,
);

DecorationImage tick = new DecorationImage(
  image: new AssetImage('assets/dpInitials.png'),
  fit: BoxFit.cover,
);

// ----------------------------------------------------------------------------

class LoginScreen extends StatefulWidget {
  const LoginScreen(MainModel model, {Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;

  var animationStatus = 0;
  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text('Are you sure?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/home"),
                  child: new Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

// ============================================================================
// ============================================================================
// ============================================================================

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    double deviceHeight = MediaQuery.of(context).size.height;
    double whiteSpace = deviceHeight > 640 ? deviceHeight - 640 : 0;
    var fmtYear = new DateFormat('y');
    String currentYear = fmtYear.format(DateTime.now());

    bool _obscureTextLogin = true;
    TextEditingController emailController;
    TextEditingController passwordController;

    void _toggleLogin() {
      setState(() {
        _obscureTextLogin = !_obscureTextLogin;
      });
    }

    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: <Color>[
                      // const Color.fromRGBO(162, 146, 199, 0.4),
                      // const Color.fromRGBO(51, 51, 63, 0.5),
                      const Color.fromRGBO(204, 255, 255, 0.8),
                      const Color.fromRGBO(51, 0, 0, 0.9),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
                  child: new ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new SizedBox(height: 64.0),
                              new Tick(image: tick),
                              new SizedBox(height: whiteSpace),
                              Container(
                                margin:
                                    new EdgeInsets.symmetric(horizontal: 20.0),
                                child: new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Form(
                                        child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
// ----------------------------------------------------------------------------

                                        new TextFormField(
                                          controller: emailController,
                                          validator: (String value) {
                                            if (value.isEmpty ||
                                                value.length < 3) {
                                              return 'Username invalid';
                                            }
                                            return null;
                                          },
                                          onSaved: (String value) {
                                            // authenBloc.authUser(value);
                                          },
                                          style: TextStyle(
                                              fontFamily: "WorkSansSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              Icons.person_outline,
                                              color: Colors.black,
                                              size: 22.0,
                                            ),
                                            hintText: "Username",
                                          ),
                                        ),

// ----------------------------------------------------------------------------

                                        new TextFormField(
                                          controller: passwordController,
                                          obscureText: _obscureTextLogin,
                                          style: TextStyle(
                                              fontFamily: "WorkSansSemiBold",
                                              fontSize: 16.0,
                                              color: Colors.black),
                                          validator: (String value) {
                                            if (value.isEmpty ||
                                                value.length < 7) {
                                              return 'Password invalid';
                                            }
                                            return null;
                                          },
                                          onSaved: (String value) {
                                            // authenBloc.authPass(value);
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              Icons.lock,
                                              size: 22.0,
                                              color: Colors.black,
                                            ),
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                fontFamily: "WorkSansSemiBold",
                                                fontSize: 17.0),
                                            suffixIcon: GestureDetector(
                                              onTap: _toggleLogin,
                                              child: Icon(
                                                Icons.remove_red_eye,
                                                size: 15.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),

// ----------------------------------------------------------------------------
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              FlatButton(
                                padding: const EdgeInsets.only(
                                  top: 160.0,
                                ),
                                onPressed: null,
                                child: new Text(
                                  "©$currentYear Accountable Warehouse Operatives Ledger",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 0.5,
                                      color: Colors.white,
                                      fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                          animationStatus == 0
                              ? new Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: new InkWell(
                                      onTap: () {
                                        // authenticate(context)
                                        //     .then((_) => setState(
                                        //           () => animationStatus = 1,
                                        //         ));
                                        _playAnimation();
                                      },
                                      child: Container(
                                        width: 320.0,
                                        height: 60.0,
                                        alignment: FractionalOffset.center,
                                        decoration: new BoxDecoration(
                                          // color: const Color.fromRGBO(247, 64, 106, 1.0),
                                          color: const Color.fromRGBO(
                                              51, 0, 0, 1.0),
                                          borderRadius: new BorderRadius.all(
                                              const Radius.circular(30.0)),
                                        ),
                                        child: new Text(
                                          "Sign In",
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      )),
                                )
                              : new StaggerAnimation(
                                  buttonController:
                                      _loginButtonController.view),
                        ],
                      ),
                    ],
                  ))),
        )));
  }
}

// ----------------------------------------------------------------------------

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = new Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        buttomZoomOut = new Tween(
          begin: 70.0,
          end: 1000.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: buttomZoomOut.value == 70
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: new InkWell(
          onTap: () {
            _playAnimation();
          },
          child: new Hero(
            tag: "fade",
            child: buttomZoomOut.value <= 300
                ? new Container(
                    width: buttomZoomOut.value == 70
                        ? buttonSqueezeanimation.value
                        : buttomZoomOut.value,
                    height:
                        buttomZoomOut.value == 70 ? 60.0 : buttomZoomOut.value,
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                      // color: const Color.fromRGBO(204, 0, 51, 1.0),
                      color: const Color.fromRGBO(51, 0, 0, 1.0),
                      borderRadius: buttomZoomOut.value < 400
                          ? new BorderRadius.all(const Radius.circular(30.0))
                          : new BorderRadius.all(const Radius.circular(0.0)),
                    ),
                    child: buttonSqueezeanimation.value > 75.0
                        ? new Text(
                            "Sign In",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          )
                        : buttomZoomOut.value < 300.0
                            ? new CircularProgressIndicator(
                                value: null,
                                strokeWidth: 1.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : null)
                : new Container(
                    width: buttomZoomOut.value,
                    height: buttomZoomOut.value,
                    decoration: new BoxDecoration(
                      shape: buttomZoomOut.value < 500
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      // color: const Color.fromRGBO(204, 0, 51, 1.0),
                      color: const Color.fromRGBO(51, 0, 0, 1.0),
                    ),
                  ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushNamed(context, "/home");
      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
