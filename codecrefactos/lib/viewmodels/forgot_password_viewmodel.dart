import 'package:flutter/material.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  final userCtrl = TextEditingController();

  String? validateUser(String? value) {
    if (value == null || value.isEmpty) return "Enter User ID";
    return null;
  }
}
