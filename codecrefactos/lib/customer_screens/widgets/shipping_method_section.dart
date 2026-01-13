import 'package:codecrefactos/customer_screens/view_models/confirm_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingMethodSection extends StatelessWidget {
  const ShippingMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConfirmOrderVM>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            _ShippingOption(
              title: 'Normal (3-5 days)',
              price: '30 EGP',
              selected: vm.selectedMethod == ShippingMethod.normal,
              onTap: () => vm.selectMethod(ShippingMethod.normal),
            ),
            const SizedBox(width: 12),
            _ShippingOption(
              title: 'Fast (1-2 days)',
              price: '70 EGP',
              selected: vm.selectedMethod == ShippingMethod.fast,
              onTap: () => vm.selectMethod(ShippingMethod.fast),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShippingOption extends StatelessWidget {
  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _ShippingOption({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                price,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
