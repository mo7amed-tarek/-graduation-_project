import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/inventory_viewmodel.dart';
import '../../customer_screens/view_models/home_view_model.dart';

class AddProductSheet extends StatefulWidget {
  final InventoryItem? item;

  const AddProductSheet({super.key, this.item});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool _isSubmitting = false;

  final List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Mobiles"},
    {"id": 2, "name": "Laptops"},
    {"id": 3, "name": "Accessories"},
  ];

  Map<String, dynamic>? selectedCategory;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      final item = widget.item!;
      nameCtrl.text = item.name;
      descCtrl.text = item.description;
      colorCtrl.text = item.color;
      priceCtrl.text = item.price.toString();
      quantityCtrl.text = item.quantity.toString();

      selectedCategory = categories.firstWhere(
        (c) => c["id"] == item.categoryId,
        orElse: () => categories.first,
      );
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    colorCtrl.dispose();
    priceCtrl.dispose();
    quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select category")));
      return;
    }

    final inventoryVM = context.read<InventoryViewModel>();
    final homeVM = context.read<HomeVM>();

    setState(() => _isSubmitting = true);

    final item = InventoryItem(
      id: widget.item?.id,
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim(),
      color: colorCtrl.text.trim(),
      pictureUrl: '',
      price: double.tryParse(priceCtrl.text) ?? 0,
      categoryName: selectedCategory!["name"],
      categoryId: selectedCategory!["id"],
      quantity: int.tryParse(quantityCtrl.text) ?? 0,
      isLowStock: (int.tryParse(quantityCtrl.text) ?? 0) <= 5,
    );

    try {
      if (widget.item != null) {
        await inventoryVM.updateItem(item);
        if (_selectedImage != null) {
          await inventoryVM.uploadImage(widget.item!.id!, _selectedImage!.path);
        }
      } else {
        final newId = await inventoryVM.addItem(item);
        if (_selectedImage != null && newId != 0) {
          await inventoryVM.uploadImage(newId, _selectedImage!.path);
        }
      }

      await homeVM.fetchProducts(refresh: true);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _inputLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 5.h, top: 12.h),
    child: Text(
      text,
      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
    ),
  );

  Widget _textField(
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          validator ??
          (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
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
              // Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              Gap(15.h),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item != null ? "Edit Product" : "Add Product",
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

              Gap(20.h),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 130.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 36.sp,
                              color: Colors.grey,
                            ),
                            Gap(8.h),
                            Text(
                              "Tap to upload image",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              _inputLabel("Name"),
              _textField(nameCtrl),

              _inputLabel("Description"),
              _textField(descCtrl),

              _inputLabel("Color"),
              _textField(colorCtrl),

              _inputLabel("Price"),
              _textField(
                priceCtrl,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),

              _inputLabel("Quantity"),
              _textField(
                quantityCtrl,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final n = int.tryParse(v);
                  if (n == null) return 'Enter a valid number';
                  if (n < 0) return 'Quantity cannot be negative';
                  return null;
                },
              ),

              _inputLabel("Category"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: DropdownButtonFormField<Map<String, dynamic>>(
                  value: selectedCategory,
                  decoration: const InputDecoration(border: InputBorder.none),
                  hint: const Text("Select Category"),
                  isExpanded: true,
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                  },
                  validator: (v) => v == null ? 'Please select category' : null,
                ),
              ),

              Gap(25.h),

              // Buttons
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
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.item != null
                                ? "Update Product"
                                : "Add Product",
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),

              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
