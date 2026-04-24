import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../Inventory Management/viewmodels/inventory_viewmodel.dart';
import 'package:codecrefactos/product_repository.dart';
import '../viewmodels/sale_model.dart';

class AddSalesSheet extends StatefulWidget {
  final SaleModel? sale;
  const AddSalesSheet({super.key, this.sale});

  @override
  State<AddSalesSheet> createState() => _AddSalesSheetState();
}

class _AddSalesSheetState extends State<AddSalesSheet> {
  final _formKey = GlobalKey<FormState>();
  final customerController = TextEditingController();
  final quantityController = TextEditingController();

  InventoryItem? _selectedProduct;
  Employee? _selectedEmployee;

  List<InventoryItem> _products = [];
  bool _isLoadingProducts = true;
  String? _productsErrorMessage;
  final ProductRepository _productRepo = ProductRepository();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _fetchProducts();
      if (!mounted) return;
      _setInitialEditValues();
    });

    if (widget.sale != null) {
      customerController.text = widget.sale!.customerName;
      quantityController.text = widget.sale!.quantity.toString();

      final vm = context.read<EmployeesViewModel>();
      if (vm.employeesList.isNotEmpty) {
        try {
          _selectedEmployee = vm.employeesList.firstWhere(
            (e) =>
                e.id == widget.sale!.employeeId ||
                e.name == widget.sale!.employeeName,
          );
        } catch (e) {
          _selectedEmployee = vm.employeesList.first;
        }
      } else {
        _selectedEmployee = null;
      }
    }
  }

  Future<void> _fetchProducts() async {
    try {
      List<InventoryItem> allProducts = [];
      int currentPage = 1;
      bool hasMore = true;

      while (hasMore) {
        final result = await _productRepo.getProducts(
          pageIndex: currentPage,
          pageSize: 50,
          sort: 'NameAsc',
        );

        if (result.items.isEmpty) break;

        allProducts.addAll(result.items);
        hasMore = result.hasMore;
        currentPage++;
      }

      if (mounted) {
        setState(() {
          _products = allProducts;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _productsErrorMessage = "Failed to load products.";
          _isLoadingProducts = false;
        });
      }
    }
  }

  void _setInitialEditValues() {
    if (widget.sale == null) return;

    if (_products.isNotEmpty) {
      try {
        _selectedProduct = _products.firstWhere(
          (p) =>
              p.id == widget.sale!.productId ||
              p.name == widget.sale!.productName,
        );
      } catch (_) {
        _selectedProduct = null;
      }
    }
    if (mounted) setState(() {});
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Gap(20.h),

              _inputLabel("Customer Name"),
              _textField(customerController),

              _inputLabel("Product"),
              _productDropdown(),

              _inputLabel("Quantity"),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }

                  final number = double.tryParse(value);
                  if (number == null) {
                    return "Enter a valid number";
                  }

                  if (number <= 0) {
                    return "Quantity must be greater than zero";
                  }

                  return null;
                },
              ),

              _inputLabel("Employee"),
              _employeeDropdown(),

              Gap(25.h),
              _buildButtons(context),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.sale != null ? "Edit Sale" : "Add New Sale",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        Gap(10.w),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text(
            widget.sale != null ? "Update" : "Add Sale",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
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

    final sale = SaleModel(
      id: widget.sale?.id,
      customerName: customerController.text,
      employeeId: _selectedEmployee!.id,
      productId: _selectedProduct!.id,
      quantity: int.parse(quantityController.text),
      status: widget.sale?.status ?? 'Pending',
    );

    Navigator.pop(context, sale);
  }

  Widget _inputLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 5.h, top: 12.h),
    child: Text(
      text,
      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
    ),
  );

  Widget _textField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
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
    if (_isLoadingProducts) {
      return Container(
        height: 50.h,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (_productsErrorMessage != null) {
      return Container(
        height: 50.h,
        alignment: Alignment.center,
        child: Text(_productsErrorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_products.isEmpty) {
      return Container(
        height: 50.h,
        alignment: Alignment.center,
        child: const Text("No products available"),
      );
    }

    if (widget.sale != null && _selectedProduct == null && _products.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setInitialEditValues();
      });
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonFormField<InventoryItem>(
        value: _products.contains(_selectedProduct) ? _selectedProduct : null,
        hint: const Text("Select Product"),
        isExpanded: true,
        decoration: const InputDecoration(border: InputBorder.none),
        items: _products.map((prod) {
          return DropdownMenuItem<InventoryItem>(
            value: prod,
            child: Text("\$${prod.price} - ${prod.name}"),
          );
        }).toList(),
        validator: (value) => value == null ? 'Please select a product' : null,
        onChanged: (value) {
          setState(() {
            _selectedProduct = value;
          });
        },
      ),
    );
  }
}
