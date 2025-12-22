import 'package:flutter/material.dart';

class Employee {
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

  Employee copyWith({
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
  List<Employee> employeesList = [];
  List<Employee> filteredEmployees = [];

  EmployeesViewModel() {
    filteredEmployees = List.from(employeesList);
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

  void addEmployee(Employee employee) {
    employeesList.add(employee);
    filteredEmployees = List.from(employeesList);
    notifyListeners();
  }

  void updateEmployee(int index, Employee employee) {
    employeesList[index] = employee;
    filteredEmployees = List.from(employeesList);
    notifyListeners();
  }

  void deleteEmployee(int index) {
    employeesList.removeAt(index);
    filteredEmployees = List.from(employeesList);
    notifyListeners();
  }

  void toggleStatus(int index) {
    employeesList[index] = employeesList[index].copyWith(
      isActive: !employeesList[index].isActive,
    );

    filteredEmployees = List.from(employeesList);
    notifyListeners();
  }
}
