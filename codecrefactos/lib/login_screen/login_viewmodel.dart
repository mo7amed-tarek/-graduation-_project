import 'package:flutter/material.dart';

enum UserRole { admin, customer }

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

  Future<UserRole> login() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (emailCtrl.text.toLowerCase().contains("admin")) {
      return UserRole.admin;
    } else {
      return UserRole.customer;
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
