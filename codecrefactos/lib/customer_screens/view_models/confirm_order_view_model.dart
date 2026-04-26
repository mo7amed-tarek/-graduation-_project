import 'package:codecrefactos/apiService.dart';
import 'package:codecrefactos/customer_screens/repositories/delivery_method_repository.dart';
import 'package:codecrefactos/customer_screens/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import '../models/delivery_method_model.dart';

enum ShippingMethod { normal, fast }

enum PaymentMethod { cash, paymob }

class ConfirmOrderVM extends ChangeNotifier {
  final ApiService apiService;

  late final DeliveryMethodRepository _deliveryRepo;
  late final PaymentRepository _paymentRepo;

  ConfirmOrderVM(this.apiService) {
    _deliveryRepo = DeliveryMethodRepository(apiService);
    _paymentRepo = PaymentRepository(apiService);
    fetchDeliveryMethods();
  }

  // ─── Shipping ───────────────────────────────────────────────────────────────
  List<DeliveryMethod> deliveryMethods = [];
  DeliveryMethod? selectedDeliveryMethod;
  bool isLoadingDelivery = false;

  Future<void> fetchDeliveryMethods() async {
    isLoadingDelivery = true;
    notifyListeners();

    deliveryMethods = await _deliveryRepo.getDeliveryMethods();

    // Default: pick the cheapest (first by price)
    if (deliveryMethods.isNotEmpty) {
      deliveryMethods.sort((a, b) => a.price.compareTo(b.price));
      selectedDeliveryMethod = deliveryMethods.first;
    }

    isLoadingDelivery = false;
    notifyListeners();
  }

  void selectDeliveryMethod(DeliveryMethod method) {
    selectedDeliveryMethod = method;
    notifyListeners();
  }

  double get shippingCost => selectedDeliveryMethod?.price.toDouble() ?? 0.0;
  int get deliveryMethodId => selectedDeliveryMethod?.id ?? 1;

  // ─── Payment ─────────────────────────────────────────────────────────────────
  PaymentMethod selectedPayment = PaymentMethod.cash;

  void selectPayment(PaymentMethod method) {
    selectedPayment = method;
    notifyListeners();
  }

  /// Always send 'Visa' to the API — the server PaymentMethod enum only accepts
  /// this value. The cash/paymob distinction is a client-side UX flow only.
  String get paymentMethodString => 'Visa';

  // ─── Pay order (Paymob only) ─────────────────────────────────────────────────
  Future<bool> payOrder(String orderId) async {
    return await _paymentRepo.payOrder(orderId);
  }

  // ─── Form controllers ────────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
