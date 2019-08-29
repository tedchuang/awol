import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './keys.dart';
import './models/user.dart';

// ---------------------------------------------------------------------------- CONNECTED MODEL

mixin ConnectedModel on Model {
  User _authenticatedUser;
  bool _isLoading = false;
  String _devicePlatform;

// ------------------------------------ Is it Loading

  bool get isLoading {
    return _isLoading;
  }

// ------------------------------------ Device Platform

  void devicePlatform() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _devicePlatform = iosInfo.utsname.machine ?? 'iOS';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _devicePlatform = androidInfo.model;
    } else {
      _devicePlatform = 'Other';
    }
  }
}

// ---------------------------------------------------------------------------- USER MODEL

mixin UserModel on ConnectedModel {
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

// ------------------------------------ Authenticate

  Future<Map<String, dynamic>> authenticate(
      String loginUser, String loginPassword) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'user': loginUser,
      'pass': loginPassword,
      'platform': _devicePlatform,
      'apiKey': apiKey,
    };
    print('authData:');
    print(authData);

    http.Response response = await http.post(
      '$apiURI/Login.pl?key=$authKey',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );

// ----------------

    final Map<String, dynamic> responseData = json.decode(response.body);
    print('responseData:');
    print(responseData);
    bool hasError = true;
    String message = 'Something went wrong.';

// ----------------

    if (responseData.containsKey('userToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
        userId: responseData['userId'],
      );

      _userSubject.add(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', responseData['userId']);
      prefs.setString('userToken', responseData['userToken']);
      prefs.setString('userFull', responseData['userFull']);

// ---------------- No auth key given; login failed

    } else if (responseData['error'] == 'NO_DATA') {
      message = 'The AWOL service has gone AWOL.\nTry again later?';
    } else if (responseData['error'] == 'INVALID_KEY') {
      message =
          'Please update your app to\nexperience the latest features. Thanks!';
    } else if (responseData['error'] == 'INVALID_PASSWORD') {
      message =
          'Password incorrect. You may want to\nuse the "Forgot Password" link below.';
    } else {
      message = responseData['error'];
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

// ------------------------------------ Auto-Authenticate

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('userToken');

    if (token != null) {
      String userId = prefs.getString('userId');
      String userToken = prefs.getString('userToken');
      String userFull = prefs.getString('userFull');

      _authenticatedUser = User(
        userId: userId,
        userToken: userToken,
        userFull: userFull,
      );

      _userSubject.add(true);
      notifyListeners();
    }
  }

// ------------------------------------ Logout

  void logout() async {
    _authenticatedUser = null;
    _userSubject.add(false);
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('usrToken');
    prefs.remove('usrFull');
  }
}
