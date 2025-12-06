import 'package:flutter/material.dart';

class Employee {
  final String name;
  final String role;
  final String email;
  final String salary;
  final bool isActive;

  Employee({
    required this.name,
    required this.role,
    required this.email,
    required this.salary,
    required this.isActive,
  });

  Employee copyWith({
    String? name,
    String? role,
    String? email,
    String? salary,
    bool? isActive,
  }) {
    return Employee(
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      salary: salary ?? this.salary,
      isActive: isActive ?? this.isActive,
    );
  }
}

class EmployeesViewModel extends ChangeNotifier {
  List<Employee> employeesList = [
    Employee(
      name: "John Smith",
      role: "Sales",
      email: "john.smith@company.com",
      salary: "\$5,000",
      isActive: true,
    ),
    Employee(
      name: "Emily Davis",
      role: "Sales",
      email: "emily.d@company.com",
      salary: "\$5,000",
      isActive: false,
    ),
    Employee(
      name: "Michael Brown",
      role: "Purchasing",
      email: "michael.b@company.com",
      salary: "\$5,000",
      isActive: true,
    ),
  ];

  List<Employee> filteredEmployees = [];

  EmployeesViewModel() {
    filteredEmployees = employeesList;
  }

  void searchEmployees(String query) {
    filteredEmployees = employeesList.where((emp) {
      final q = query.toLowerCase();
      return emp.name.toLowerCase().contains(q) ||
          emp.email.toLowerCase().contains(q);
    }).toList();
    notifyListeners();
  }

  void deleteEmployee(int index) {
    filteredEmployees.removeAt(index);
    notifyListeners();
  }

  void toggleStatus(int index) {
    filteredEmployees[index] = filteredEmployees[index].copyWith(
      isActive: !filteredEmployees[index].isActive,
    );
    notifyListeners();
  }
}
