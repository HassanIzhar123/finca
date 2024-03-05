import 'package:flutter/material.dart';

class GlobalUI {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    messengerKey.currentState?.showSnackBar(snackBar);
  }
}
