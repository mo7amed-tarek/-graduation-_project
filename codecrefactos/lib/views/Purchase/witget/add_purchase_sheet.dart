import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
  final supplierController = TextEditingController();
  final amountController = TextEditingController();
  final employeeController = TextEditingController();

  String? selectedCategory;
  String? selectedProduct;
  String status = 'Pending';

  @override
  void initState() {
    super.initState();
    if (widget.purchase != null) {
      supplierController.text = widget.purchase!.supplierName;
      amountController.text = widget.purchase!.amount;
      employeeController.text = widget.purchase!.employee;
      selectedCategory = widget.purchase!.category;
      selectedProduct = widget.purchase!.product;
      status = widget.purchase!.status;
    }
  }

  @override
  void dispose() {
    supplierController.dispose();
    amountController.dispose();
    employeeController.dispose();
    super.dispose();
  }

  List<String> get _categories => ['Select Category', ...PurchasesConstants.categoriesWithProducts.keys];
  List<String> get _productsForSelectedCategory {
    if (selectedCategory == null || !PurchasesConstants.categoriesWithProducts.containsKey(selectedCategory)) {
      return ['Select Product'];
    }
    return ['Select Product', ...PurchasesConstants.categoriesWithProducts[selectedCategory!]!];
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
                  widget.isEdit ? "Edit Purchase Order" : "Add New Purchase Order",
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
            _inputLabel("Supplier Name"),
            _textField(supplierController),
            _inputLabel("Category"),
            CustomDropdownField(
              hint: 'Select Category',
              value: (selectedCategory != null) ? selectedCategory : null,
              items: PurchasesConstants.categoriesWithProducts.keys.toList(),
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
              value: (selectedProduct != null) ? selectedProduct : null,
              items: selectedCategory != null
                  ? PurchasesConstants.categoriesWithProducts[selectedCategory!]!
                  : const [],
              onChanged: (val) {
                setState(() {
                  selectedProduct = val;
                });
              },
            ),
            _inputLabel("Amount"),
            _textField(amountController, keyboardType: TextInputType.number),
            _inputLabel("Employee"),
            _textField(employeeController),
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
                  onPressed: _submit,
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
                    widget.isEdit ? "Save Changes" : "Add Purchase",
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

  void _submit() {
    if (supplierController.text.isEmpty ||
        selectedCategory == null ||
        selectedProduct == null ||
        amountController.text.isEmpty ||
        employeeController.text.isEmpty) {
      return;
    }

    final purchase = Purchase(
      invoiceNumber: widget.purchase?.invoiceNumber ?? '',
      supplierName: supplierController.text,
      category: selectedCategory!,
      product: selectedProduct!,
      employee: employeeController.text,
      amount: amountController.text,
      status: widget.isEdit ? status : 'Pending',
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

  Widget _textField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
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
    );
  }
}
