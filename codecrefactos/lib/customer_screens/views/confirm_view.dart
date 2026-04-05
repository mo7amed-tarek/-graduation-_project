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

  static final GlobalKey<FormState> _customerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartVM>();

    return ChangeNotifierProvider(
      create: (_) => ConfirmOrderVM(),
      child: Builder(
        builder: (context) {
          final confirmVM = context.watch<ConfirmOrderVM>();

          double totalPrice = cartVM.total + confirmVM.shippingCost;

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

                  TotalSection(total: totalPrice),

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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Confirm Order?'),
                            content: Text(
                              'Total: ${totalPrice.toStringAsFixed(0)} EGP\n\nAre you sure you want to confirm?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  cartVM.clear();

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const OrderConfirmedScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Confirm'),
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
