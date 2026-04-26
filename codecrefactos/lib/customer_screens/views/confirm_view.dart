import 'package:codecrefactos/customer_screens/widgets/confirm_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'package:codecrefactos/customer_screens/widgets/CustomButton.dart';
import 'package:codecrefactos/customer_screens/widgets/order_summary_list.dart';
import 'package:codecrefactos/customer_screens/widgets/customer_info_form.dart';
import 'package:codecrefactos/customer_screens/widgets/payment_methods_row.dart';
import 'package:codecrefactos/customer_screens/widgets/shipping_method_section.dart';
import 'package:codecrefactos/customer_screens/widgets/total_section.dart';
import 'package:codecrefactos/customer_screens/view_models/cart_view_model.dart';
import 'package:codecrefactos/customer_screens/view_models/confirm_order_view_model.dart';
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
                        text: cartVM.isLoading ? 'Processing...' : 'Confirm Order',
                        onPressed: cartVM.isLoading
                            ? () {}
                            : () => _handleConfirm(context, cartVM, confirmVM, totalPrice),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty!')),
      );
      return;
    }
    if (!(_customerFormKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all customer info correctly')),
      );
      return;
    }

    if (confirmVM.selectedPayment == PaymentMethod.paymob) {
      // Navigate to full-screen Paymob card page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymobCardPage(
            cartVM: cartVM,
            confirmVM: confirmVM,
            totalPrice: totalPrice,
          ),
        ),
      );
    } else {
      // Cash: go straight to confirm dialog
      _showConfirmDialog(context, cartVM, confirmVM, totalPrice);
    }
  }

  void _showConfirmDialog(
    BuildContext context,
    CartVM cartVM,
    ConfirmOrderVM confirmVM,
    double totalPrice,
  ) {
    ConfirmOrderView.showOrderConfirmDialog(context, cartVM, confirmVM, totalPrice);
  }

  /// Static so it can be called from PaymobCardPage after popping back
  static void showOrderConfirmDialog(
    BuildContext context,
    CartVM cartVM,
    ConfirmOrderVM confirmVM,
    double totalPrice,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Order?'),
        content: Text(
          'Payment: ${confirmVM.selectedPayment == PaymentMethod.paymob ? "Paymob" : "Cash"}\n'
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

  static Future<void> _placeOrder(
    BuildContext context,
    CartVM cartVM,
    ConfirmOrderVM confirmVM,
  ) async {
    // ⚠️ Capture navigator & messenger BEFORE any await — context may unmount
    // during async operations and Navigator calls would silently do nothing.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final order = await cartVM.createOrder(
      address: confirmVM.addressController.text.trim(),
      phone: confirmVM.phoneController.text.trim(),
      deliveryMethodId: confirmVM.deliveryMethodId,
      paymentMethod: confirmVM.paymentMethodString, // always 'Visa'
    );

    if (order != null) {
      if (confirmVM.selectedPayment == PaymentMethod.paymob) {
        final paid = await confirmVM.payOrder(order.id);
        if (!paid) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Payment failed, but order was created.'),
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
        const SnackBar(content: Text('Failed to create order, please try again.')),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Paymob Credit Card Full-Screen Page
// ═══════════════════════════════════════════════════════════════════════════════
class PaymobCardPage extends StatefulWidget {
  final CartVM cartVM;
  final ConfirmOrderVM confirmVM;
  final double totalPrice;

  const PaymobCardPage({
    super.key,
    required this.cartVM,
    required this.confirmVM,
    required this.totalPrice,
  });

  @override
  State<PaymobCardPage> createState() => _PaymobCardPageState();
}

class _PaymobCardPageState extends State<PaymobCardPage> {
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color _primary = Color(0xFF1565C0);
  static const Color _light = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Give the CreditCardForm a blue theme matching the app
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primary,
          primary: _primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.black87),
          floatingLabelStyle: const TextStyle(color: _primary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        useMaterial3: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset('assets/paymob.jpeg', height: 28),
              ),
              const SizedBox(width: 10),
              const Text(
                'Card Payment',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Animated Credit Card ─────────────────────────────────────
              CreditCardWidget(
                cardNumber: _cardNumber,
                expiryDate: _expiryDate,
                cardHolderName: _cardHolderName,
                cvvCode: _cvvCode,
                showBackView: _isCvvFocused,
                cardBgColor: _primary,
                bankName: 'Paymob',
                isChipVisible: true,
                isSwipeGestureEnabled: true,
                enableFloatingCard: true,
                floatingConfig: FloatingConfig(
                  isGlareEnabled: true,
                  isShadowEnabled: true,
                  shadowConfig: FloatingShadowConfig(
                    offset: const Offset(0, 14),
                    color: Colors.blue.shade900.withValues(alpha: 0.35),
                    blurRadius: 22,
                  ),
                ),
                onCreditCardWidgetChange: (_) {},
              ),

              // ── Total pill ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_primary, _light],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: _primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.receipt_long, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Total to pay',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.totalPrice.toStringAsFixed(0)} EGP',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Credit Card Form ─────────────────────────────────────────
              CreditCardForm(
                formKey: _formKey,
                cardNumber: _cardNumber,
                expiryDate: _expiryDate,
                cardHolderName: _cardHolderName,
                cvvCode: _cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                enableCvv: true,
                obscureCvv: true,
                obscureNumber: false,
                onCreditCardModelChange: (CreditCardModel model) {
                  setState(() {
                    _cardNumber = model.cardNumber;
                    _expiryDate = model.expiryDate;
                    _cardHolderName = model.cardHolderName;
                    _cvvCode = model.cvvCode;
                    _isCvvFocused = model.isCvvFocused;
                  });
                },
                inputConfiguration: const InputConfiguration(
                  cardNumberDecoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                  ),
                  expiryDateDecoration: InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                  ),
                  cvvCodeDecoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '•••',
                  ),
                  cardHolderDecoration: InputDecoration(
                    labelText: 'Card Holder Name',
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Pay Button ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    onPressed: _onPayPressed,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Pay Now',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _onPayPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
      ConfirmOrderView.showOrderConfirmDialog(
        context,
        widget.cartVM,
        widget.confirmVM,
        widget.totalPrice,
      );
    }
  }
}
