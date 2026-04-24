import 'package:flutter/material.dart';
import 'package:codecrefactos/apiService.dart';
import 'package:codecrefactos/views/dashboard/dashboard_model.dart';
import 'package:dio/dio.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  DashboardModel? dashboardData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchDashboardData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.get('Dashboard');
      
      if (response.statusCode == 200 && response.data != null) {
        dashboardData = DashboardModel.fromJson(response.data);
      } else {
        errorMessage = 'Failed to load dashboard data.';
      }
    } on DioException catch (e) {
      final errors = apiService.handleError(e);
      errorMessage = errors.values.firstOrNull ?? 'An error occurred';
    } catch (e) {
      errorMessage = 'An unexpected error occurred.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
