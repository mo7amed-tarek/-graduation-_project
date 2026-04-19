import 'package:flutter/material.dart';
import 'package:codecrefactos/employwee_screen/api/employee_api.dart';

class Employee {
  final int? id;
  final String name;
  final String role;
  final String email;
  final String salary;
  final bool isActive;
  final String department;

  final String? phone;
  final String? joinDate;
  final List<String>? permissions;

  Employee({
    this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.salary,
    this.isActive = false,
    required this.department,
    this.phone,
    this.joinDate,
    this.permissions,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'] ?? '',
      role: json['position'] ?? '',
      email: json['email'] ?? '',
      salary: json['salary']?.toString() ?? '0',
      isActive: _parseStatus(json['status']),
      department: _intToDepartment(json['department']),
      phone: json['phone'],
      joinDate: json['joinDate'],
    );
  }

  static bool _parseStatus(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'active';
    return true; // default fallback
  }

  static String _intToDepartment(dynamic value) {
    if (value is int) {
      if (value == 1) return "Sales";
      if (value == 2) return "IT";
      return "HR";
    }
    return value?.toString() ?? "HR";
  }

  int get departmentInt {
    switch (department) {
      case "Sales":
        return 1;
      case "IT":
        return 2;
      case "HR":
      default:
        return 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'position': role,
      'email': email,
      'salary': double.tryParse(salary) ?? 0.0,
      'status': isActive ? "Active" : "Inactive",
      'department': departmentInt,
      'phone': phone,
      'joinDate': joinDate ?? DateTime.now().toIso8601String(),
    };
  }

  Employee copyWith({
    int? id,
    String? name,
    String? role,
    String? email,
    String? salary,
    bool? isActive,
    String? department,
    String? phone,
    String? joinDate,
    List<String>? permissions,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      salary: salary ?? this.salary,
      isActive: isActive ?? this.isActive,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      joinDate: joinDate ?? this.joinDate,
      permissions: permissions ?? this.permissions,
    );
  }
}

class EmployeesViewModel extends ChangeNotifier {
  final EmployeeApi _api = EmployeeApi();

  List<Employee> employeesList = [];
  List<Employee> filteredEmployees = [];

  bool isLoading = false;
  String? errorMessage;

  EmployeesViewModel() {
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _api.getAllEmployees();
      employeesList = data.map((json) => Employee.fromJson(json)).toList();
      filteredEmployees = List.from(employeesList);
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void searchEmployees(String query) {
    final q = query.toLowerCase();
    filteredEmployees = employeesList.where((emp) {
      final nameMatch = emp.name.toLowerCase().contains(q);
      final emailMatch = emp.email.toLowerCase().contains(q);
      final phoneMatch =
          emp.phone != null && emp.phone!.toLowerCase().contains(q);
      return nameMatch || emailMatch || phoneMatch;
    }).toList();
    notifyListeners();
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await _api.createEmployee(employee.toJson());
      await fetchEmployees();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateEmployee(int index, Employee employee) async {
    final empId = employeesList[index].id;
    if (empId == null) return;
    try {
      await _api.updateEmployee(empId, employee.toJson());
      await fetchEmployees();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(int index) async {
    final empId = employeesList[index].id;
    if (empId == null) {
      // If no ID (like local fallback), remove locally
      employeesList.removeAt(index);
      filteredEmployees = List.from(employeesList);
      notifyListeners();
      return;
    }
    try {
      await _api.deleteEmployee(empId);
      await fetchEmployees();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleStatus(int index) async {
    final emp = employeesList[index];
    if (emp.id == null) return;
    final updatedEmp = emp.copyWith(isActive: !emp.isActive);

    // Optimistic update
    employeesList[index] = updatedEmp;
    filteredEmployees = List.from(employeesList);
    notifyListeners();

    try {
      await _api.updateEmployee(emp.id!, updatedEmp.toJson());
      await fetchEmployees(); // Optional: Re-sync with server
    } catch (e) {
      errorMessage = e.toString();
      // Revert if failed
      employeesList[index] = emp;
      filteredEmployees = List.from(employeesList);
      notifyListeners();
    }
  }
}
