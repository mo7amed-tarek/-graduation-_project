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
import 'package:codecrefactos/customer_screens/views/payment_webview_screen.dart';
import 'package:codecrefactos/apiService.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  Confirm Order Screen
// ═══════════════════════════════════════════════════════════════════════════════
class ConfirmOrderView extends StatelessWidget {
  const ConfirmOrderView({super.key});

  static final GlobalKey<FormState> _customerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartVM>();
    final apiService = context.read<ApiService>();

    return ChangeNotifierProvider(
      create: (_) => ConfirmOrderVM(apiService),
      child: Builder(
        builder: (context) {
          final confirmVM = context.watch<ConfirmOrderVM>();
          final double totalPrice = cartVM.total + confirmVM.shippingCost;

          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: const Text('Confirm Order'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderSummaryList(items: cartVM.items),
                      const SizedBox(height: 24),
                      CustomerInfoForm(
                        formKey: _customerFormKey,
                        nameController: confirmVM.nameController,
                        phoneController: confirmVM.phoneController,
                        addressController: confirmVM.addressController,
                      ),
                      const SizedBox(height: 24),
                      const PaymentMethodsRow(),
                      const SizedBox(height: 24),
                      const ShippingMethodSection(),
                      const SizedBox(height: 24),
                      TotalSection(total: totalPrice),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: cartVM.isLoading
                            ? 'Processing...'
                            : 'Confirm Order',
                        onPressed: cartVM.isLoading
                            ? () {}
                            : () => _handleConfirm(
                                context,
                                cartVM,
                                confirmVM,
                                totalPrice,
                              ),
                      ),
                    ],
                  ),
                ),
                if (cartVM.isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleConfirm(
    BuildContext context,
    CartVM cartVM,
    ConfirmOrderVM confirmVM,
    double totalPrice,
  ) {
    if (cartVM.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cart is empty!')));
      return;
    }
    if (!(_customerFormKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all customer info correctly'),
        ),
      );
      return;
    }

    _showConfirmDialog(context, cartVM, confirmVM, totalPrice);
  }

  void _showConfirmDialog(
    BuildContext context,
    CartVM cartVM,
    ConfirmOrderVM confirmVM,
    double totalPrice,
  ) {
    final paymentLabel = confirmVM.selectedPayment == PaymentMethod.visa
        ? 'Visa'
        : 'Cash';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Order?'),
        content: Text(
          'Payment: $paymentLabel\n'
          'Total: ${totalPrice.toStringAsFixed(0)} EGP\n\n'
          'Are you sure you want to confirm?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _placeOrder(context, cartVM, confirmVM);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(
    BuildContext context,
    CartVM cartVM,
    ConfirmOrderVM confirmVM,
  ) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final order = await cartVM.createOrder(
      address: confirmVM.addressController.text.trim(),
      phone: confirmVM.phoneController.text.trim(),
      deliveryMethodId: confirmVM.deliveryMethodId,
      paymentMethod: confirmVM.paymentMethodString,
    );

    if (order != null) {
      if (confirmVM.selectedPayment == PaymentMethod.visa) {
        final paymentUrl = await confirmVM.getOnlinePaymentUrl(order.id);

        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          debugPrint('💳 PAYMENT URL: $paymentUrl');

          await navigator.push(
            MaterialPageRoute(
              builder: (_) => PaymentWebViewScreen(paymentUrl: paymentUrl),
            ),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                'Could not retrieve payment link. Order was created.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      await cartVM.clear();

      // Navigate to success screen, clearing all routes except home
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OrderConfirmedScreen()),
        (route) => route.isFirst,
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to create order, please try again.'),
        ),
      );
    }
  }
}
