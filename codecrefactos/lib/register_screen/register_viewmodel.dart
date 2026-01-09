import 'package:flutter/material.dart';

class RegisterViewModel with ChangeNotifier {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final repeatPassCtrl = TextEditingController();

  String? validateEmail(String? value) {
    if (value == "") return "Email required";
    if (!value!.contains("@")) return "Invalid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == "") return "Password required";
    if (value!.length < 6) return "Too short";
    return null;
  }

  String? validateRepeat(String? value) {
    if (value != passCtrl.text) return "Passwords don't match";
    return null;
  }
}
