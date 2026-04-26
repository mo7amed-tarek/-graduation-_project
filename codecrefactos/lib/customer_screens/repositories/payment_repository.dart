import 'package:codecrefactos/apiService.dart';
import 'package:flutter/foundation.dart';

class PaymentRepository {
  final ApiService apiService;

  PaymentRepository(this.apiService);

  /// Calls POST /api/Orders/{id}/pay
  Future<bool> payOrder(String orderId) async {
    try {
      final response = await apiService.post('Orders/$orderId/pay', null);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('PAY ORDER ERROR: $e');
      return false;
    }
  }
}
