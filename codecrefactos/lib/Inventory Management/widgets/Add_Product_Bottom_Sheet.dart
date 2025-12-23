import 'package:codecrefactos/Inventory%20Management/viewmodels/inventory_viewmodel.dart';
import 'package:codecrefactos/Inventory%20Management/widgets/category_dropdown.dart';
import 'package:codecrefactos/Inventory%20Management/widgets/product_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductSheet extends StatefulWidget {
  final InventoryItem? item;
  final int? index;

  const AddProductSheet({super.key, this.item, this.index});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final currentQtyCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final unitPriceCtrl = TextEditingController();

  String? selectedCategory;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      final item = widget.item!;
      nameCtrl.text = item.name;
      unitPriceCtrl.text = item.unitPrice.toString();
      selectedCategory = item.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<InventoryViewModel>();

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Add / Edit Product",
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

              const SizedBox(height: 20),

              // Form
              Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    isFormValid =
                        _formKey.currentState!.validate() &&
                            selectedCategory != null;
                  });
                },
                child: Column(
                  children: [
                    ProductTextField(
                      label: "Product Name",
                      controller: nameCtrl,
                    ),

                    CategoryDropdown(
                      value: selectedCategory,
                      onChanged: (val) =>
                          setState(() => selectedCategory = val),
                    ),

                    ProductTextField(
                      label: "Current Quantity",
                      controller: currentQtyCtrl,
                      isNumber: true,
                    ),

                    ProductTextField(
                      label: "Quantity",
                      controller: quantityCtrl,
                      isNumber: true,
                    ),

                    ProductTextField(
                      label: "Unit Price",
                      controller: unitPriceCtrl,
                      isNumber: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
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
                      onPressed: isFormValid
                          ? () {
                        final current =
                        double.tryParse(currentQtyCtrl.text);
                        final quantity =
                        double.tryParse(quantityCtrl.text);
                        final unitPrice =
                        double.tryParse(unitPriceCtrl.text);

                        if (current == null ||
                            quantity == null ||
                            unitPrice == null) {
                          return;
                        }

                        final ratio = current / quantity;

                        final newItem = InventoryItem(
                          name: nameCtrl.text.trim(),
                          category: selectedCategory!,
                          date: DateTime.now()
                              .toString()
                              .split(' ')
                              .first,
                          unitPrice: unitPrice,
                          stockRatio: ratio,
                          isLowStock: ratio <= 0.2,
                        );

                        if (widget.index != null) {
                          vm.deleteItem(widget.index!);
                        }

                        vm.addItem(newItem);
                        Navigator.pop(context);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        widget.item != null
                            ? "Update Product"
                            : "Add Product",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
