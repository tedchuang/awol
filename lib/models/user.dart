import 'package:flutter/material.dart';

class User {
  String userId;
  String userFull;
  String userToken;

  User({
    @required this.userId,
    this.userFull,
    this.userToken,
  });
}
