import 'package:codecrefactos/customer_screens/view_models/confirm_order_view_model.dart';
import 'package:codecrefactos/customer_screens/models/delivery_method_model.dart';
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
        if (vm.isLoadingDelivery)
          const Center(child: CircularProgressIndicator())
        else if (vm.deliveryMethods.isEmpty)
          const Text(
            'No shipping methods available.',
            style: TextStyle(color: Colors.red),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: vm.deliveryMethods.map((method) {
              final selected = vm.selectedDeliveryMethod?.id == method.id;
              return _ShippingOption(
                method: method,
                selected: selected,
                onTap: () => vm.selectDeliveryMethod(method),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _ShippingOption extends StatelessWidget {
  final DeliveryMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _ShippingOption({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              method.shortName,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              method.deliveryTime,
              style: TextStyle(
                color: selected ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${method.price.toStringAsFixed(0)} EGP',
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
