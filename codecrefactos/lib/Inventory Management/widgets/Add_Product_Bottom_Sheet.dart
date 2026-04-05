import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/inventory_viewmodel.dart';

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
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<InventoryViewModel>();

    final item = InventoryItem(
      id: widget.item?.id,
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim(),
      color: colorCtrl.text.trim(),
      pictureUrl: "",
      price: double.tryParse(priceCtrl.text) ?? 0,
      categoryName: widget.item?.categoryName ?? '',
      categoryId: int.tryParse(categoryIdCtrl.text) ?? 0,
      quantity: int.tryParse(quantityCtrl.text) ?? 0,
      isLowStock: (int.tryParse(quantityCtrl.text) ?? 0) <= 5,
    );

    if (widget.item != null) {
      // update
      await vm.updateItem(item);

      if (_selectedImage != null) {
        await vm.uploadImage(widget.item!.id!, _selectedImage!.path);
      }
    } else {
      // add
      final newId = await vm.addItem(item);

      if (_selectedImage != null) {
        await vm.uploadImage(newId, _selectedImage!.path);
      }
    }

    if (mounted) Navigator.pop(context);
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
                _buildField("Category ID", categoryIdCtrl, isNumber: true),
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
                        onPressed: isFormValid ? _submit : null,
                        child: Text(widget.item != null ? "Update" : "Add"),
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
