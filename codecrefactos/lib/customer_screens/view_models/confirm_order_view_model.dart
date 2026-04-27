import 'package:codecrefactos/apiService.dart';
import 'package:codecrefactos/customer_screens/repositories/delivery_method_repository.dart';
import 'package:flutter/material.dart';
import '../models/delivery_method_model.dart';

enum ShippingMethod { normal, fast }

enum PaymentMethod { cash, visa }

class ConfirmOrderVM extends ChangeNotifier {
  final ApiService apiService;

  late final DeliveryMethodRepository _deliveryRepo;

  ConfirmOrderVM(this.apiService) {
    _deliveryRepo = DeliveryMethodRepository(apiService);
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
  /// this value.
  String get paymentMethodString => 'Visa';

  /// Calls POST /api/Orders/online/{orderId} and returns the payment gateway URL.
  Future<String?> getOnlinePaymentUrl(String orderId) async {
    try {
      final response = await apiService.post('Orders/online/$orderId', null);
      if (response.statusCode == 200 && response.data != null) {
        // The response is a JSON map with a 'paymentUrl' field
        if (response.data is Map) {
          final url = response.data['paymentUrl'] ?? response.data['url'];
          if (url != null) return url.toString();
        }
        // The response could be a plain string URL
        if (response.data is String) {
          return response.data as String;
        }
      }
    } catch (e) {
      debugPrint('GET ONLINE PAYMENT URL ERROR: $e');
    }
    return null;
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
