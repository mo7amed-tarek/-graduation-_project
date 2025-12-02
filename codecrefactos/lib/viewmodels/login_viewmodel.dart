import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter your email";
    if (!value.contains("@")) return "Invalid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 6) return "Password must be 6+ chars";
    return null;
  }

  void login() {
    // call API
  }
}
