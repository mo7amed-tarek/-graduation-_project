import 'package:codecrefactos/apiService.dart';
import 'package:flutter/foundation.dart';
import '../models/delivery_method_model.dart';

class DeliveryMethodRepository {
  final ApiService apiService;

  DeliveryMethodRepository(this.apiService);

  Future<List<DeliveryMethod>> getDeliveryMethods() async {
    try {
      final response = await apiService.get('Orders/deliveryMethods');
      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((e) => DeliveryMethod.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('GET DELIVERY METHODS ERROR: $e');
    }
    return [];
  }
}
