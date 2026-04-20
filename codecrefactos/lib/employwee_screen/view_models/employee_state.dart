import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../api/employee_api.dart';

enum EmployeeStateStatus { initial, loading, data, error }

class EmployeeState extends ChangeNotifier {
  final EmployeeApi _api = EmployeeApi();

  EmployeeStateStatus status = EmployeeStateStatus.initial;
  String? errorMessage;
  
  List<Employee> employees = [];
  Employee? selectedEmployee;

  Future<void> fetchEmployees() async {
    status = EmployeeStateStatus.loading;
    notifyListeners();

    try {
      final data = await _api.getAllEmployees();
      employees = data.map((json) => Employee.fromJson(json)).toList();
      status = EmployeeStateStatus.data;
    } catch (e) {
      errorMessage = e.toString();
      status = EmployeeStateStatus.error;
    }
    notifyListeners();
  }

  Future<void> fetchEmployeeById(int id) async {
    status = EmployeeStateStatus.loading;
    notifyListeners();

    try {
      final data = await _api.getEmployeeById(id);
      selectedEmployee = Employee.fromJson(data);
      status = EmployeeStateStatus.data;
    } catch (e) {
      errorMessage = e.toString();
      status = EmployeeStateStatus.error;
    }
    notifyListeners();
  }

  Future<bool> createEmployee(Map<String, dynamic> employeeData) async {
    status = EmployeeStateStatus.loading;
    notifyListeners();

    try {
      await _api.createEmployee(employeeData);
      await fetchEmployees();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      status = EmployeeStateStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEmployee(int id, Map<String, dynamic> updatedData) async {
    status = EmployeeStateStatus.loading;
    notifyListeners();

    try {
      await _api.updateEmployee(id, updatedData);
      await fetchEmployees();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      status = EmployeeStateStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEmployee(int id) async {
    status = EmployeeStateStatus.loading;
    notifyListeners();

    try {
      await _api.deleteEmployee(id);
      await fetchEmployees();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      status = EmployeeStateStatus.error;
      notifyListeners();
      return false;
    }
  }
}
