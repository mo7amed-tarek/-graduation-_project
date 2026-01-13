import 'package:codecrefactos/customer_screens/widgets/confirm_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codecrefactos/customer_screens/widgets/CustomButton.dart';
import 'package:codecrefactos/customer_screens/widgets/order_summary_list.dart';
import 'package:codecrefactos/customer_screens/widgets/customer_info_form.dart';
import 'package:codecrefactos/customer_screens/widgets/payment_methods_row.dart';
import 'package:codecrefactos/customer_screens/widgets/shipping_method_section.dart';
import 'package:codecrefactos/customer_screens/widgets/total_section.dart';
import 'package:codecrefactos/customer_screens/view_models/cart_view_model.dart';
import 'package:codecrefactos/customer_screens/view_models/confirm_order_view_model.dart';

class ConfirmOrderView extends StatelessWidget {
  const ConfirmOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartVM>();

    final _customerFormKey = GlobalKey<FormState>();

    return ChangeNotifierProvider(
      create: (_) => ConfirmOrderVM(),
      child: Builder(
        builder: (context) {
          final confirmVM = context.watch<ConfirmOrderVM>();

          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: const Text('Confirm Order'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderSummaryList(items: cartVM.items),
                  const SizedBox(height: 24),

                  CustomerInfoForm(formKey: _customerFormKey),
                  const SizedBox(height: 24),

                  const PaymentMethodsRow(),
                  const SizedBox(height: 24),

                  const ShippingMethodSection(),
                  const SizedBox(height: 24),

                  TotalSection(total: cartVM.total + confirmVM.shippingCost),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Confirm Order',
                    onPressed: () {
                      if (cartVM.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cart is empty!')),
                        );
                        return;
                      }

                      if (!(_customerFormKey.currentState?.validate() ??
                          false)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill all customer info correctly',
                            ),
                          ),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirm Order?'),
                            content: Text(
                              'Do you want to confirm this order which costs \$${cartVM.total + confirmVM.shippingCost}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('No, Cancel'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  cartVM.clear();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const OrderConfirmedScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Yes, Confirm'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
