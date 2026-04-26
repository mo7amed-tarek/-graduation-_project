import 'package:codecrefactos/apiService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final _api = ApiService();

  bool isLoading = false;
  String message = '';

  String _savedEmail = '';
  String get savedEmail => _savedEmail;

  String _savedToken = '';
  String get savedToken => _savedToken;

  Future<void> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      message = 'Please enter your email';
      notifyListeners();
      return;
    }

    isLoading = true;
    message = '';
    notifyListeners();

    try {
      await _api.post('User/forgot-password', {'email': email.trim()});

      _savedEmail = email.trim();
      message = 'OTP sent to $email';
    } on DioException catch (e) {
      final errors = _api.handleError(e);
      message = errors['general'] ?? errors['email'] ?? 'Failed to send OTP';
    } catch (_) {
      message = 'Failed to send OTP';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (otp.trim().isEmpty) {
      message = 'Please enter the OTP';
      notifyListeners();
      return false;
    }

    _savedToken = otp.trim();
    return true;
  }

  Future<bool> updatePassword(String password, String confirm) async {
    if (password != confirm) {
      message = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      message = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    isLoading = true;
    message = '';
    notifyListeners();

    try {
      await _api.post('User/reset-password', {
        'email': _savedEmail,
        'token': _savedToken,
        'newPassword': password,
        'confirmNewPassword': confirm,
      });

      message = 'Password updated successfully';
      return true;
    } on DioException catch (e) {
      final errors = _api.handleError(e);
      message =
          errors['general'] ??
          errors['password'] ??
          'Failed to update password';
      return false;
    } catch (_) {
      message = 'Failed to update password';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
