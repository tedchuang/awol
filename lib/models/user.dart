import 'package:flutter/material.dart';

class User {
  String userId;
  String userFull;
  String userWhse;
  String userToken;

  User({
    @required this.userId,
    this.userFull,
    this.userWhse,
    this.userToken,
  });
}
