import 'package:codecrefactos/viewmodels/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddSalesSheet extends StatefulWidget {
  AddSalesSheet({super.key, this.isEdit = false, this.sale});
  final bool isEdit;
  final SaleModel? sale;

  @override
  State<AddSalesSheet> createState() => _AddSalesSheetState();
}

class _AddSalesSheetState extends State<AddSalesSheet> {
  final CustomerNameController = TextEditingController();
  final CategoryController = TextEditingController();
  final EmployeeController = TextEditingController();
  final AmountNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sale != null) {
      CustomerNameController.text = widget.sale!.customerName;
      CategoryController.text = widget.sale!.category;
      AmountNameController.text = widget.sale!.amount.toString();
      EmployeeController.text = widget.sale!.employee;
    }
  }

  @override
  void dispose() {
    CustomerNameController.dispose();
    CategoryController.dispose();
    EmployeeController.dispose();
    AmountNameController.dispose();
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
                  widget.isEdit == true ? "Edit Sale" : "Add New Sale",
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
            _textField(CustomerNameController),
            _inputLabel("Category"),
            _textField(CategoryController),
            _inputLabel("Amount"),
            _textField(AmountNameController),
            _inputLabel("Employee"),
            _textField(EmployeeController),

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
                    if (CustomerNameController.text.isEmpty ||
                        CategoryController.text.isEmpty ||
                        EmployeeController.text.isEmpty ||
                        AmountNameController.text.isEmpty) {
                      return;
                    }
                    if (widget.isEdit == true) {
                      final saleData = SaleModel(
                        customerName: CustomerNameController.text,
                        category: CategoryController.text,
                        employee: EmployeeController.text,
                        amount: AmountNameController.text,
                      );
                      Navigator.pop(context, saleData);
                    } else {
                      final editData = SaleModel(
                        customerName: CustomerNameController.text,
                        category: CategoryController.text,
                        employee: EmployeeController.text,
                        amount: AmountNameController.text,
                      );
                      Navigator.pop(context, editData);
                    }
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
                    widget.isEdit == true ? "Save Changes" : "Add Sale",
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
}
