import 'package:flutter/material.dart';

class NotifToken with ChangeNotifier {
  String notifToken = "";

  String get getNotifToken => notifToken;
  void set setNotifToken(String token) => {this.notifToken = token};
}
