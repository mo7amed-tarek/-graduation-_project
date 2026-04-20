class Employee {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? position;
  final String? department;
  final double? salary;
  final bool? status;
  final String? joinDate;
  final List<String>? permissions;

  Employee({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.position,
    this.department,
    this.salary,
    this.status,
    this.joinDate,
    this.permissions,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      position: json['position'] as String?,
      department: json['department'] as String?,
      salary: json['salary'] != null ? double.tryParse(json['salary'].toString()) : null,
      status: json['status'] as bool?,
      joinDate: json['joinDate'] as String?,
      permissions: json['permissions'] != null 
          ? List<String>.from(json['permissions']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'position': position,
      'department': department,
      'salary': salary,
      'status': status,
      'joinDate': joinDate,
      'permissions': permissions,
    };
  }
}
