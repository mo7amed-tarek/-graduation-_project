import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../apiService.dart';

class RegisterViewModel with ChangeNotifier {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();

  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isRegistered = false;

  String? emailError;
  String? passwordError;
  String? nameError;
  String? generalError;

  void clearErrors() {
    emailError = null;
    passwordError = null;
    nameError = null;
    generalError = null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email required";
    if (!value.contains("@")) return "Invalid email";
    if (emailError != null) return emailError;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password required";
    if (value.length < 6) return "Too short";
    if (passwordError != null) return passwordError;
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return "Full name required";
    if (nameError != null) return nameError;
    return null;
  }

  Map<String, dynamic> getRegisterData() {
    return {
      "email": emailCtrl.text.trim(),
      "password": passCtrl.text.trim(),
      "fullName": fullNameCtrl.text.trim(),
    };
  }

  Future<void> register() async {
    isLoading = true;
    isRegistered = false;
    clearErrors();
    notifyListeners();

    try {
      final response = await apiService.post(
        "User/register",
        getRegisterData(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isRegistered = true;
      }
    } on DioException catch (e) {
      final resData = e.response?.data;

      if (resData is String && resData.trim().isNotEmpty) {
        final msg = resData.trim().toLowerCase();
        if (msg.contains("email")) {
          emailError = resData.trim();
        } else if (msg.contains("password")) {
          passwordError = resData.trim();
        } else if (msg.contains("name")) {
          nameError = resData.trim();
        } else {
          generalError = resData.trim();
        }
      } else if (resData is List) {
        for (var item in resData) {
          if (item is Map) {
            final code = item['code']?.toString().toLowerCase();
            final description = item['description']?.toString();

            if (code != null && description != null) {
              if (code.contains("email")) {
                emailError = description;
              } else if (code.contains("password")) {
                passwordError = description;
              } else if (code.contains("name")) {
                nameError = description;
              } else {
                generalError = description;
              }
            }
          }
        }
      } else if (resData is Map) {
        if (resData['message'] != null) {
          generalError = resData['message'].toString();
        } else if (resData['title'] != null) {
          generalError = resData['title'].toString();
        }
      } else {
        generalError = "Registration failed. Please try again.";
      }
    } catch (e) {
      generalError = "Unexpected error occurred";
    }

    isLoading = false;
    notifyListeners();
  }

  bool hasErrors() {
    return emailError != null ||
        passwordError != null ||
        nameError != null ||
        generalError != null;
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    fullNameCtrl.dispose();
    super.dispose();
  }
}
