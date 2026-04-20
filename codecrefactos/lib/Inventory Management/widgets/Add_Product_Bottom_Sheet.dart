import 'dart:io';
import 'package:flutter/material.dart';
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

  bool isFormValid = false;
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

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,

    labelStyle: const TextStyle(color: Colors.grey),

    floatingLabelStyle: const TextStyle(color: Colors.grey),

    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    ),
  );
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

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: _inputDeco(label),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Form(
          key: _formKey,
          onChanged: () {
            setState(() {
              isFormValid = _formKey.currentState?.validate() ?? false;
            });
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // handle
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

                const SizedBox(height: 15),

                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.item != null ? "Edit Product" : "Add Product",
                      style: const TextStyle(
                        fontSize: 20,
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
                  "Fill product details below",
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const SizedBox(height: 20),

                // image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, size: 40),
                              SizedBox(height: 8),
                              Text("Tap to upload image"),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                _field("Name", nameCtrl),
                _field("Description", descCtrl),
                _field("Color", colorCtrl),

                Row(
                  children: [
                    Expanded(child: _field("Price", priceCtrl, number: true)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field("Quantity", quantityCtrl, number: true),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedCategory,
                    decoration: _inputDeco("Category"),
                    items: categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat["name"]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCategory = value);
                    },
                    validator: (v) =>
                        v == null ? 'Please select category' : null,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (isFormValid && !_isSubmitting) ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            widget.item != null
                                ? "Update Product"
                                : "Add Product",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
