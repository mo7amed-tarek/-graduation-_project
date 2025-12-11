import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../viewmodels/employee_viewmodel.dart';

class AddEmployeeSheet extends StatefulWidget {
  final EmployeesViewModel vm;
  final Employee? employee;
  final int? index;

  const AddEmployeeSheet({
    super.key,
    required this.vm,
    this.employee,
    this.index,
  });

  @override
  State<AddEmployeeSheet> createState() => _AddEmployeeSheetState();
}

class _AddEmployeeSheetState extends State<AddEmployeeSheet> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();
  final salaryController = TextEditingController();
  String? selectedDepartment;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      nameController.text = widget.employee!.name;
      emailController.text = widget.employee!.email;
      phoneController.text = widget.employee!.phone ?? '';
      positionController.text = widget.employee!.role;
      salaryController.text = widget.employee!.salary;
      selectedDepartment = widget.employee!.department;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.employee != null
                      ? "Edit Employee"
                      : "Add New Employee",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Text(
              "Enter employee information",
              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),
            Gap(20.h),
            _inputLabel("Name"),
            _textField(nameController),
            _inputLabel("Email"),
            _textField(emailController),
            _inputLabel("Phone"),
            _textField(phoneController),
            _inputLabel("Position"),
            _textField(positionController),
            _inputLabel("Department"),
            _dropDown(),
            _inputLabel("Salary"),
            _textField(salaryController),
            Gap(25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                Gap(10.w),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        positionController.text.isEmpty ||
                        salaryController.text.isEmpty ||
                        selectedDepartment == null) {
                      return;
                    }

                    final newEmployee = Employee(
                      name: nameController.text,
                      role: positionController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      salary: salaryController.text,
                      isActive: widget.employee?.isActive ?? true,
                      department: selectedDepartment!,
                    );

                    if (widget.employee != null && widget.index != null) {
                      widget.vm.updateEmployee(widget.index!, newEmployee);
                    } else {
                      widget.vm.addEmployee(newEmployee);
                    }

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    widget.employee != null ? "Save" : "Add Employee",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h, top: 12.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _textField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropDown() {
    List<String> departments = ["HR", "Sales", "IT"];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButton<String>(
        value: departments.contains(selectedDepartment)
            ? selectedDepartment
            : null,
        hint: const Text("Select department"),
        underline: const SizedBox(),
        isExpanded: true,
        items: departments
            .map((dep) => DropdownMenuItem(value: dep, child: Text(dep)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedDepartment = value;
          });
        },
      ),
    );
  }
}
