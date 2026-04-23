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
  Employee? _selectedEmployee;
  String status = 'PendingOrder';

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<InventoryViewModel>().loadItems(refresh: true);

      if (!mounted) return;
      _setInitialEditValues();
      _updateFormValidity();
    });

    Future.microtask(() {
      if (!mounted) return;
      _setInitialEditValues();
      _updateFormValidity();
    });

    if (widget.purchase != null) {
      supplierController.text = widget.purchase!.supplierName;
      quantityController.text = widget.purchase!.quantity.toString();
      status = widget.purchase!.status;
    }

    supplierController.addListener(_updateFormValidity);
    quantityController.addListener(_updateFormValidity);
  }

  void _setInitialEditValues() {
    if (widget.purchase == null) return;

    final inventoryVm = context.read<InventoryViewModel>();
    final employeeVm = context.read<EmployeesViewModel>();

    if (inventoryVm.items.isNotEmpty) {
      try {
        _selectedProduct = inventoryVm.items.firstWhere(
          (p) =>
              p.id == widget.purchase!.productId ||
              p.name == widget.purchase!.productName,
        );
      } catch (_) {
        _selectedProduct = null;
      }
    }

    if (employeeVm.employeesList.isNotEmpty) {
      try {
        _selectedEmployee = employeeVm.employeesList.firstWhere(
          (e) =>
              e.id == widget.purchase!.employeeId ||
              e.name == widget.purchase!.employeeName,
        );
      } catch (_) {
        _selectedEmployee = null;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _updateFormValidity() {
    if (!mounted) return;

    final isValid =
        supplierController.text.trim().isNotEmpty &&
        int.tryParse(quantityController.text.trim()) != null &&
        int.parse(quantityController.text.trim()) > 0 &&
        _selectedProduct != null &&
        _selectedEmployee != null;

    if (isFormValid != isValid) {
      setState(() {
        isFormValid = isValid;
      });
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    supplierController.removeListener(_updateFormValidity);
    quantityController.removeListener(_updateFormValidity);
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Gap(10.w),
                ElevatedButton(
                  onPressed: isFormValid ? _submit : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    widget.isEdit ? "Save Changes" : "Add Purchase",
                    style: const TextStyle(color: Colors.white),
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

    final quantity = int.parse(quantityController.text.trim());

    final purchase = Purchase(
      id: widget.purchase?.id,
      supplierName: supplierController.text.trim(),
      employeeId: _selectedEmployee!.id,
      productId: _selectedProduct!.id,
      quantity: quantity,
      price: _selectedProduct!.price,
      status: widget.isEdit ? status : 'PendingOrder',
    );

    Navigator.pop(context, purchase);
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

        if (widget.purchase != null &&
            _selectedEmployee == null &&
            activeEmployees.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _setInitialEditValues();
            _updateFormValidity();
          });
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DropdownButtonFormField<Employee>(
            value: activeEmployees.contains(_selectedEmployee)
                ? _selectedEmployee
                : null,
            decoration: const InputDecoration(border: InputBorder.none),
            hint: const Text("Select Employee"),
            isExpanded: true,
            items: activeEmployees.map((emp) {
              return DropdownMenuItem<Employee>(
                value: emp,
                child: Text(emp.name),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select an employee' : null,
            onChanged: (value) {
              _selectedEmployee = value;
              _updateFormValidity();
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

        if (widget.purchase != null &&
            _selectedProduct == null &&
            products.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _setInitialEditValues();
            _updateFormValidity();
          });
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DropdownButtonFormField<InventoryItem>(
            value: products.contains(_selectedProduct)
                ? _selectedProduct
                : null,
            decoration: const InputDecoration(border: InputBorder.none),
            hint: const Text("Select Product"),
            isExpanded: true,
            items: products.map((prod) {
              return DropdownMenuItem<InventoryItem>(
                value: prod,
                child: Text("\$${prod.price} - ${prod.name}"),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select a product' : null,
            onChanged: (value) {
              _selectedProduct = value;
              _updateFormValidity();
            },
          ),
        );
      },
    );
  }
}
