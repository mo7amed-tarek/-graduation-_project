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
  final qtyCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final minCtrl = TextEditingController();
  final maxCtrl = TextEditingController();

  String? selectedCategory;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      final item = widget.item!;
      nameCtrl.text = item.name;
      locationCtrl.text = item.warehouse;
      qtyCtrl.text = (item.stockRatio * 100).toStringAsFixed(0);
      minCtrl.text = item.isLowStock ? qtyCtrl.text : "0";
      maxCtrl.text = "100";
      selectedCategory = item.category;
      isFormValid = true;
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
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add / Edit Product",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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
                      controller: qtyCtrl,
                      isNumber: true,
                    ),
                    ProductTextField(
                      label: "Location",
                      controller: locationCtrl,
                    ),
                    ProductTextField(
                      label: "Minimum Quantity",
                      controller: minCtrl,
                      isNumber: true,
                    ),
                    ProductTextField(
                      label: "Maximum Quantity",
                      controller: maxCtrl,
                      isNumber: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isFormValid
                          ? () {
                              final current = double.parse(qtyCtrl.text);
                              final max = double.parse(maxCtrl.text);
                              final min = double.parse(minCtrl.text);

                              final newItem = InventoryItem(
                                name: nameCtrl.text.trim(),
                                category: selectedCategory!,
                                warehouse: locationCtrl.text.trim(),
                                date: DateTime.now()
                                    .toString()
                                    .split(' ')
                                    .first,
                                stockRatio: current / max,
                                isLowStock: current <= min,
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
                        disabledBackgroundColor: const Color(
                          0xFF2563EB,
                        ).withOpacity(0.35),
                        disabledForegroundColor: Colors.white,
                      ),
                      child: Text(
                        widget.item != null ? "Update Product" : "Add Product",
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
