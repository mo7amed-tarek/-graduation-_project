import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/inventory_viewmodel.dart';
import '../../customer_screens/view_models/home_view_model.dart'; // ✅ إضافة

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
  final categoryIdCtrl = TextEditingController();
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
      categoryIdCtrl.text = item.categoryId.toString();
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
    categoryIdCtrl.dispose();
    quantityCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
    final homeVM = context.read<HomeVM>(); // ✅ إضافة

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

      // ✅ أهم سطر: تحديث HomeVM
      await homeVM.fetchProducts(refresh: true);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Product",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : const Center(child: Text("Tap to select image")),
                  ),
                ),

                const SizedBox(height: 14),

                _buildField("Name", nameCtrl),
                _buildField("Description", descCtrl),
                _buildField("Color", colorCtrl),
                _buildField("Price", priceCtrl, isNumber: true),

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
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    validator: (v) =>
                        v == null ? 'Please select category' : null,
                  ),
                ),

                _buildField("Quantity", quantityCtrl, isNumber: true),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (isFormValid && !_isSubmitting)
                            ? _submit
                            : null,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(widget.item != null ? "Update" : "Add"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
