import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../viewmodels/purchase_model.dart';
import '../viewmodels/PurchasesConstants.dart';
import '../../sales/widget/CustomDropdownField.dart';

class AddPurchaseSheet extends StatefulWidget {
  const AddPurchaseSheet({super.key, this.isEdit = false, this.purchase});

  final bool isEdit;
  final Purchase? purchase;

  @override
  State<AddPurchaseSheet> createState() => _AddPurchaseSheetState();
}

class _AddPurchaseSheetState extends State<AddPurchaseSheet> {
  final _formKey = GlobalKey<FormState>();

  final supplierController = TextEditingController();
  final amountController = TextEditingController();

  String? selectedCategory;
  String? selectedProduct;
  String status = 'Pending';
  Employee? _selectedEmployee;

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    final vm = context.read<EmployeesViewModel>();

    if (widget.purchase != null) {
      supplierController.text = widget.purchase!.supplierName;
      amountController.text = widget.purchase!.amount;
      selectedCategory = widget.purchase!.category;
      selectedProduct = widget.purchase!.product;
      status = widget.purchase!.status;

      if (vm.employeesList.isNotEmpty) {
        try {
          _selectedEmployee = vm.employeesList.firstWhere(
            (e) => e.name == widget.purchase!.employee,
          );
        } catch (e) {
          _selectedEmployee = vm.employeesList.first;
        }
      }
    }
  }

  @override
  void dispose() {
    supplierController.dispose();
    amountController.dispose();
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
                  widget.isEdit
                      ? "Edit Purchase Order"
                      : "Add New Purchase Order",
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
              "Enter purchase order details",
              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),

            Gap(20.h),

            Form(
              key: _formKey,
              onChanged: () {
                setState(() {
                  isFormValid =
                      _formKey.currentState!.validate() &&
                      selectedCategory != null &&
                      selectedProduct != null &&
                      _selectedEmployee != null;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _inputLabel("Supplier Name"),
                  _textField(
                    controller: supplierController,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Supplier name is required'
                        : null,
                  ),

                  _inputLabel("Category"),
                  CustomDropdownField(
                    hint: 'Select Category',
                    value: selectedCategory,
                    items: PurchasesConstants.categoriesWithProducts.keys
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val;
                        selectedProduct = null;
                      });
                    },
                  ),

                  _inputLabel("Product"),
                  CustomDropdownField(
                    hint: 'Select Product',
                    value: selectedProduct,
                    items: selectedCategory != null
                        ? PurchasesConstants
                              .categoriesWithProducts[selectedCategory!]!
                        : const [],
                    onChanged: (val) {
                      setState(() => selectedProduct = val);
                    },
                  ),

                  _inputLabel("Amount"),
                  _textField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      final number = double.tryParse(val);
                      if (number == null || number <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      return null;
                    },
                  ),

                  _inputLabel("Employee"),
                  _employeeDropdown(),
                ],
              ),
            ),

            Gap(30.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isFormValid ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      widget.isEdit ? "Save Changes" : "Add Purchase",
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

  void _submit() {
    final purchase = Purchase(
      invoiceNumber: widget.purchase?.invoiceNumber ?? '',
      supplierName: supplierController.text.trim(),
      category: selectedCategory!,
      product: selectedProduct!,
      employee: _selectedEmployee!.name,
      amount: amountController.text.trim(),
      status: widget.isEdit ? status : 'Pending',
    );

    Navigator.pop(context, purchase);
  }

  /// ===== UI Helpers =====
  Widget _inputLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h, top: 12.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
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

  Widget _employeeDropdown() {
    return Consumer<EmployeesViewModel>(
      builder: (context, vm, _) {
        final activeEmployees = vm.employeesList
            .where((e) => e.isActive)
            .toList();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DropdownButton<Employee>(
            value: activeEmployees.contains(_selectedEmployee)
                ? _selectedEmployee
                : null,
            hint: const Text("Select Employee"),
            isExpanded: true,
            underline: const SizedBox(),
            items: activeEmployees.map((emp) {
              return DropdownMenuItem<Employee>(
                value: emp,
                child: Text(emp.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedEmployee = value;
              });
            },
          ),
        );
      },
    );
  }
}
