import 'package:flutter/material.dart';

class ProductTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumber;

  const ProductTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Required";
                }

                if (isNumber) {
                  final number = double.tryParse(value);

                  if (number == null) {
                    return "Enter valid number";
                  }

                  if (number < 0) {
                    return "Cannot be negative";
                  }

                  if (number == 0) {
                    return "Must be greater than 0";
                  }
                }

                return null;
              },

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
