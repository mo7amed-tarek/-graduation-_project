import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  bool isLoading = false;
  String message = '';

  Future<void> resetPassword(String userId) async {
    isLoading = true;
    message = '';
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));
      message = 'OTP sent to $userId';
    } catch (e) {
      message = 'Failed to send OTP';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String otp) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    if (otp == "1234") {
      return true;
    } else {
      message = "Invalid OTP";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String password, String confirm) async {
    if (password != confirm) {
      message = "Passwords do not match";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));
      message = "Password updated successfully";
      return true;
    } catch (e) {
      message = "Failed to update password";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
