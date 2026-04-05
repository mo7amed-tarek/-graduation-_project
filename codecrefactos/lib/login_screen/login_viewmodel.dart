import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../apiService.dart';

class LoginViewModel with ChangeNotifier {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final ApiService apiService = ApiService();

  bool isLoading = false;

  String? token;
  String? role;

  Map<String, String> fieldErrors = {};

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter your email";
    if (!value.contains("@")) return "Invalid email";
    if (fieldErrors.containsKey("email")) return fieldErrors["email"];
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 6) return "Password must be 6+ chars";
    if (fieldErrors.containsKey("password")) return fieldErrors["password"];
    return null;
  }

  Map<String, dynamic> getLoginData() {
    return {
      "email": emailCtrl.text.trim(),
      "password": passwordCtrl.text.trim(),
    };
  }

  Future<bool> login() async {
    isLoading = true;
    fieldErrors = {};
    notifyListeners();

    try {
      final data = getLoginData();
      final response = await apiService.post("User/login", data);

      if (response.statusCode == 200) {
        token = response.data['token'] as String?;
        role = response.data['role'] as String?;
        ApiService.token = token;
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      final resData = e.response?.data;

      Map<String, String> errors = {};

      if (resData is List) {
        for (var item in resData) {
          if (item is Map) {
            final code = item['code']?.toString().toLowerCase();
            final description = item['description']?.toString();

            if (code != null && description != null) {
              if (code.contains("email")) {
                errors["email"] = description;
              } else if (code.contains("password")) {
                errors["password"] = description;
              } else {
                errors["general"] = description;
              }
            }
          }
        }
      } else if (resData is Map) {
        if (resData['message'] != null) {
          errors["general"] = resData['message'].toString();
        } else if (resData['title'] != null) {
          errors["general"] = resData['title'].toString();
        }
      } else if (resData is String && resData.trim().isNotEmpty) {
        errors["general"] = resData.trim();
      } else {
        errors["general"] = "Login failed. Please try again.";
      }

      fieldErrors = errors;
      notifyListeners();
      return false;
    } catch (e) {
      fieldErrors = {"general": e.toString()};
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearErrors() {
    fieldErrors = {};
    notifyListeners();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
