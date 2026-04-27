import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          autovalidateMode:
              AutovalidateMode.onUserInteraction, // ✅ validation أثناء الكتابة
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(context),
              Gap(20.h),

              // ✅ Name — string مطلوب
              _inputLabel("Name"),
              _textField(
                nameController,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Name is required";
                  if (v.trim().length < 3)
                    return "Name must be at least 3 characters";
                  return null;
                },
              ),

              // ✅ Email — لازم يكون فيه @
              _inputLabel("Email"),
              _textField(
                emailController,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Email is required";
                  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
                  if (!emailRegex.hasMatch(v.trim())) {
                    return "Enter a valid email (e.g. user@example.com)";
                  }
                  return null;
                },
              ),

              // ✅ Phone — أرقام بس
              _inputLabel("Phone"),
              _textField(
                phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Phone is required";
                  if (v.length < 10) return "Phone must be at least 10 digits";
                  return null;
                },
              ),

              // ✅ Position — string مطلوب
              _inputLabel("Position"),
              _textField(
                positionController,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return "Position is required";
                  if (v.trim().length < 2) return "Enter a valid position";
                  return null;
                },
              ),

              _inputLabel("Department"),
              _dropDown(),

              _inputLabel("Salary"),
              _salaryField(),

              Gap(25.h),
              _actions(context),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.employee != null ? "Edit Employee" : "Add New Employee",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        Gap(10.w),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate() ||
                selectedDepartment == null) {
              if (selectedDepartment == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a department")),
                );
              }
              return;
            }

            final newEmployee = Employee(
              name: nameController.text.trim(),
              role: positionController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              salary: salaryController.text.trim(),
              department: selectedDepartment!,
              isActive: widget.employee?.isActive ?? false,
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
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            widget.employee != null ? "Save" : "Add Employee",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
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

  Widget _textField(
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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

  Widget _salaryField() {
    return TextFormField(
      controller: salaryController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return "Salary is required";
        final salary = int.tryParse(value);
        if (salary == null) return "Enter a valid number";
        if (salary <= 0) return "Salary must be greater than 0";
        return null;
      },
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
    List<String> departments = [
      "Sales",
      "Purchasing",
      "Warehouse",
      "Technical",
      "Management",
    ];
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
