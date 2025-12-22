import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../viewmodels/sale_model.dart';

class AddSalesSheet extends StatefulWidget {
  AddSalesSheet({super.key, this.sale});

  final SaleModel? sale;

  @override
  State<AddSalesSheet> createState() => _AddSalesSheetState();
}

class _AddSalesSheetState extends State<AddSalesSheet> {
  final customerController = TextEditingController();
  final categoryController = TextEditingController();
  final employeeController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sale != null) {
      customerController.text = widget.sale!.customerName;
      categoryController.text = widget.sale!.category;
      employeeController.text = widget.sale!.employee;
      amountController.text = widget.sale!.amount;
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    categoryController.dispose();
    employeeController.dispose();
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
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.sale != null ? "Edit Sale" : "Add New Sale",
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
              "Enter sale details",
              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),
            Gap(20.h),

            _inputLabel("Customer Name"),
            _textField(customerController),

            _inputLabel("Category"),
            _textField(categoryController),

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
                  child: const Text(
                    "Add Sale",
                    style: TextStyle(
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
    if (customerController.text.isEmpty ||
        categoryController.text.isEmpty ||
        employeeController.text.isEmpty ||
        amountController.text.isEmpty)
      return;

    final sale = SaleModel(
      invoiceNumber: widget.sale?.invoiceNumber ?? '',
      customerName: customerController.text,
      category: categoryController.text,
      employee: employeeController.text,
      amount: amountController.text,
      status: 'Pending',
    );

    Navigator.pop(context, sale);
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
