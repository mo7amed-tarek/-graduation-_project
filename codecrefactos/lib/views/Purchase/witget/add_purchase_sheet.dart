import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../viewmodels/purchase_model.dart';
import '../../../Inventory Management/viewmodels/inventory_viewmodel.dart';

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
  final quantityController = TextEditingController();

  InventoryItem? _selectedProduct;
  String status = 'PendingOrder';
  Employee? _selectedEmployee;

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<InventoryViewModel>().loadItems(refresh: true);
    });

    final vm = context.read<EmployeesViewModel>();

    if (widget.purchase != null) {
      supplierController.text = widget.purchase!.supplierName;
      quantityController.text = widget.purchase!.quantity.toString();
      status = widget.purchase!.status;

      final inventoryVm = context.read<InventoryViewModel>();
      if (inventoryVm.items.isNotEmpty) {
        try {
          _selectedProduct = inventoryVm.items.firstWhere(
            (p) => p.id == widget.purchase!.productId || p.name == widget.purchase!.productName,
          );
        } catch (_) {}
      }

      if (vm.employeesList.isNotEmpty) {
        try {
          _selectedEmployee = vm.employeesList.firstWhere(
            (e) => e.id == widget.purchase!.employeeId || e.name == widget.purchase!.employeeName,
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
    quantityController.dispose();
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
                      _selectedProduct != null &&
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

                  _inputLabel("Product"),
                  _productDropdown(),

                  _inputLabel("Quantity"),
                  _textField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() {}),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Required';
                      final number = int.tryParse(val);
                      if (number == null || number <= 0) return 'Must be > 0';
                      return null;
                    },
                  ),

                  if (_selectedProduct != null &&
                      quantityController.text.isNotEmpty &&
                      int.tryParse(quantityController.text) != null &&
                      int.parse(quantityController.text) > 0)
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        "Total Price: \$${(_selectedProduct!.price * int.parse(quantityController.text)).toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
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
    if (!_formKey.currentState!.validate() ||
        _selectedProduct == null ||
        _selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    final purchase = Purchase(
      id: widget.purchase?.id,
      supplierName: supplierController.text.trim(),
      employeeId: _selectedEmployee!.id,
      productId: _selectedProduct!.id,
      quantity: int.parse(quantityController.text.trim()),
      price: _selectedProduct!.price * int.parse(quantityController.text.trim()),
      status: widget.isEdit ? status : 'PendingOrder',
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
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
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

  Widget _productDropdown() {
    return Consumer<InventoryViewModel>(
      builder: (context, vm, _) {
        final products = vm.items;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DropdownButton<InventoryItem>(
            value: products.contains(_selectedProduct)
                ? _selectedProduct
                : null,
            hint: const Text("Select Product"),
            isExpanded: true,
            underline: const SizedBox(),
            items: products.map((prod) {
              return DropdownMenuItem<InventoryItem>(
                value: prod,
                child: Text("\$${prod.price} - ${prod.name}"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedProduct = value;
              });
            },
          ),
        );
      },
    );
  }
}
