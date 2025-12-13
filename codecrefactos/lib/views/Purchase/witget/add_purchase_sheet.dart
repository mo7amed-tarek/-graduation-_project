import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddPurchaseSheet extends StatefulWidget {


  const AddPurchaseSheet({
    super.key,

  });

  @override
  State<AddPurchaseSheet> createState() => _AddPurchaseSheetState();
}

class _AddPurchaseSheetState extends State<AddPurchaseSheet> {
  final CustomerNameController = TextEditingController();
  final CategoryController = TextEditingController();
  final AmountController = TextEditingController();
  final EmployeeNameController = TextEditingController();

  @override
  // void initState() {
  //   super.initState();
  //   if (widget.employee != null) {
  //     nameController.text = widget.employee!.name;
  //     emailController.text = widget.employee!.email;
  //     phoneController.text = widget.employee!.phone ?? '';
  //     positionController.text = widget.employee!.role;
  //     salaryController.text = widget.employee!.salary;
  //     selectedDepartment = widget.employee!.department;
  //   }
  // }

  @override
  void dispose() {
    CustomerNameController.dispose();
    CategoryController.dispose();
    AmountController.dispose();
    EmployeeNameController.dispose();
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
                  "Add New Purchase Order",
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
            _textField(CustomerNameController),
            _inputLabel("Category"),
            _textField(CategoryController),
            _inputLabel("Quantity"),
            _textField(AmountController),
            _inputLabel("Amount"),
            _textField(EmployeeNameController),

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
                        AmountController.text.isEmpty ||
                        EmployeeNameController.text.isEmpty)
                      return;




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
                    "Add Sales",
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
