import 'package:codecrefactos/customer_screens/widgets/confirm_widgets.dart';
import 'package:codecrefactos/widgets/chat_button.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            floatingActionButton: ChatFloatingButton(),
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
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderSummaryList(items: cartVM.items),
                      SizedBox(height: 24.h),
                      CustomerInfoForm(
                        formKey: _customerFormKey,
                        nameController: confirmVM.nameController,
                        phoneController: confirmVM.phoneController,
                        addressController: confirmVM.addressController,
                      ),
                      SizedBox(height: 24.h),
                      const PaymentMethodsRow(),
                      SizedBox(height: 24.h),
                      const ShippingMethodSection(),
                      SizedBox(height: 24.h),
                      TotalSection(total: totalPrice),
                      SizedBox(height: 24.h),
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
    final paymentLabel = confirmVM.paymentMethodString;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Confirm Order?'),
        content: Text(
          'Payment: $paymentLabel\n'
          'Total: ${totalPrice.toStringAsFixed(0)} EGP\n\n'
          'Are you sure you want to confirm?',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14.sp,
            height: 1.6.h,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _placeOrder(context, cartVM, confirmVM);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
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

    final (order, errorMessage) = await cartVM.createOrder(
      address: confirmVM.addressController.text.trim(),
      phone: confirmVM.phoneController.text.trim(),
      deliveryMethodId: confirmVM.deliveryMethodId,
      paymentMethod: confirmVM.paymentMethodString,
    );

    if (errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

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

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OrderConfirmedScreen()),
        (route) => route.isFirst,
      );
    }
  }
}
