import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDetailsSheet extends StatefulWidget {
  final Employee employee;
  final int index;

  const EmployeeDetailsSheet({
    super.key,
    required this.employee,
    required this.index,
  });

  @override
  State<EmployeeDetailsSheet> createState() => _EmployeeDetailsSheetState();
}

class _EmployeeDetailsSheetState extends State<EmployeeDetailsSheet> {
  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController emailController;
  late TextEditingController salaryController;
  late TextEditingController departmentController;
  late TextEditingController phoneController;
  late TextEditingController joinDateController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;
    nameController = TextEditingController(text: emp.name);
    roleController = TextEditingController(text: emp.role);
    emailController = TextEditingController(text: emp.email);
    salaryController = TextEditingController(text: emp.salary);
    departmentController = TextEditingController(text: emp.department);
    phoneController = TextEditingController(text: emp.phone ?? '');
    joinDateController = TextEditingController(text: emp.joinDate ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    emailController.dispose();
    salaryController.dispose();
    departmentController.dispose();
    phoneController.dispose();
    joinDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EmployeesViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Employee Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue, // لون الأفاتار
                  child: Text(
                    (widget.employee.name.isNotEmpty
                        ? widget.employee.name.substring(0, 2).toUpperCase()
                        : "--"),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // لون النص داخل الأفاتار
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.employee.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // لون الاسم
                      ),
                    ),
                    Text(
                      widget.employee.role,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildField(
              Icons.email_outlined,
              "Email",
              widget.employee.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildField(
              Icons.phone_outlined,
              "Phone",
              widget.employee.phone ?? "-",
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildField(
              Icons.calendar_today_outlined,
              "Join Date",
              widget.employee.joinDate ?? "-",
              controller: joinDateController,
            ),
            _buildField(
              Icons.business_outlined,
              "Department",
              widget.employee.department,
              controller: departmentController,
            ),
            _buildField(
              Icons.attach_money,
              "Salary",
              widget.employee.salary,
              controller: salaryController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(140, 42),
                  ),
                  onPressed: () {
                    if (isEditing) {
                      final updatedEmployee = widget.employee.copyWith(
                        name: nameController.text,
                        role: roleController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        joinDate: joinDateController.text,
                        department: departmentController.text,
                        salary: salaryController.text,
                      );
                      vm.updateEmployee(widget.index, updatedEmployee);
                      setState(() => isEditing = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Employee updated successfully"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      setState(() => isEditing = true);
                    }
                  },
                  child: Text(
                    isEditing ? "Save" : "Edit Employee",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    IconData icon,
    String label,
    String value, {
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                isEditing && controller != null
                    ? TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      )
                    : Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
