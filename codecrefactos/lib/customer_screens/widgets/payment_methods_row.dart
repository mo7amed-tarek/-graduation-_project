import 'package:codecrefactos/customer_screens/view_models/confirm_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodsRow extends StatelessWidget {
  const PaymentMethodsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConfirmOrderVM>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _PaymentOption(
              image: 'assets/cash_icon.png',
              label: 'Cash',
              selected: vm.selectedPayment == PaymentMethod.cash,
              onTap: () => vm.selectPayment(PaymentMethod.cash),
            ),
            const SizedBox(width: 12),
            _PaymentOption(
              image: 'assets/Visa.png',
              label: 'Visa',
              selected: vm.selectedPayment == PaymentMethod.visa,
              onTap: () => vm.selectPayment(PaymentMethod.visa),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String image;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.image,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(image, height: 50, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.blue : Colors.black87,
                ),
              ),
              if (selected) ...[
                const SizedBox(height: 4),
                Icon(Icons.check_circle, size: 18, color: Colors.blue.shade600),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
