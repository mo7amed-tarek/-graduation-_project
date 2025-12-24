import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../viewmodels/SalesConstants.dart';
import '../viewmodels/sale_model.dart';
import 'CustomDropdownField.dart';

class AddSalesSheet extends StatefulWidget {
  final SaleModel? sale;
  const AddSalesSheet({super.key, this.sale});

  @override
  State<AddSalesSheet> createState() => _AddSalesSheetState();
}

class _AddSalesSheetState extends State<AddSalesSheet> {
  final _formKey = GlobalKey<FormState>();
  final customerController = TextEditingController();
  final employeeController = TextEditingController();
  final amountController = TextEditingController();

  String? _selectedCategory;
  String? _selectedProduct;

  @override
  void initState() {
    super.initState();
    if (widget.sale != null) {
      customerController.text = widget.sale!.customerName;
      employeeController.text = widget.sale!.employee;
      amountController.text = widget.sale!.amount;
      _selectedCategory = widget.sale!.category;
      _selectedProduct = widget.sale!.product;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w, right: 20.w, top: 20.h,
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

              // ... (بقية الكود كما هو في البداية)

              _inputLabel("Category"),
              CustomDropdownField(
                hint: "Select Category",
                value: _selectedCategory,
                items: SalesConstants.categoriesWithProducts.keys.toList(),
                onChanged: (val) => setState(() {
                  _selectedCategory = val;
                  _selectedProduct = null;
                }),
              ),

              _inputLabel("Product"),
              CustomDropdownField(
                hint: _selectedCategory == null
                    ? "Select category first"
                    : "Select Product",
                value: _selectedProduct,
                items: _selectedCategory != null
                    ? SalesConstants.categoriesWithProducts[_selectedCategory!]!
                    : [],
                onChanged: _selectedCategory == null
                    ? (val) {}
                    : (val) => setState(() => _selectedProduct = val),
              ),

              _inputLabel("Amount"),
              _textField(amountController, keyboardType: TextInputType.number),

              _inputLabel("Employee"),
              _textField(employeeController),

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
        Text(widget.sale != null ? "Edit Sale" : "Add New Sale",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        Gap(10.w),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text(widget.sale != null ? "Update" : "Add Sale",
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedCategory == null || _selectedProduct == null) return;

    final sale = SaleModel(
      invoiceNumber: widget.sale?.invoiceNumber ?? '',
      customerName: customerController.text,
      category: _selectedCategory!,
      product: _selectedProduct!,
      employee: employeeController.text,
      amount: amountController.text,
      status: widget.sale?.status ?? 'Pending',
    );
    Navigator.pop(context, sale);
  }

  Widget _inputLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 5.h, top: 12.h),
    child: Text(text, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
  );

  Widget _textField(TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true, fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }
}