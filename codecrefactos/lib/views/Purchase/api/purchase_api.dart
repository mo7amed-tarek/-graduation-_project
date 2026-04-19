import '../../../apiService.dart';

class PurchaseApi {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllPurchases() async {
    try {
      final response = await _apiService.get('Purchases/GetAllPurchase');
      if (response.statusCode == 200) {
        return response.data;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load purchases: $e');
    }
  }

  Future<Map<String, dynamic>> getPurchaseById(int id) async {
    try {
      final response = await _apiService.get('Purchases/GetPurchaseById/$id');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Purchase not found');
    } catch (e) {
      throw Exception('Failed to load purchase details: $e');
    }
  }

  Future<void> createPurchase(Map<String, dynamic> purchaseData) async {
    try {
      final response = await _apiService.post('Purchases/CreatePurchase', purchaseData);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create purchase');
      }
    } catch (e) {
      throw Exception('Failed to create purchase: $e');
    }
  }

  Future<void> updatePurchase(int id, Map<String, dynamic> updatedData) async {
    try {
      final response = await _apiService.patch('Purchases/UpdatePurchase/$id', updatedData);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to update purchase');
      }
    } catch (e) {
      throw Exception('Failed to update purchase: $e');
    }
  }

  Future<void> deletePurchase(int id) async {
    try {
      final response = await _apiService.delete('Purchases/DeletePurchase/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete purchase');
      }
    } catch (e) {
      throw Exception('Failed to delete purchase: $e');
    }
  }
}
