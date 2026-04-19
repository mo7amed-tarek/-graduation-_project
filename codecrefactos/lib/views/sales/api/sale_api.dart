import '../../../apiService.dart';

class SaleApi {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllSales() async {
    try {
      final response = await _apiService.get('Sales/GetAllSales');
      if (response.statusCode == 200) {
        return response.data;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load sales: $e');
    }
  }

  Future<Map<String, dynamic>> getSaleById(int id) async {
    try {
      final response = await _apiService.get('Sales/GetSaleById/$id');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Sale not found');
    } catch (e) {
      throw Exception('Failed to load sale details: $e');
    }
  }

  Future<void> createSale(Map<String, dynamic> saleData) async {
    try {
      final response = await _apiService.post('Sales/CreateSale', saleData);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create sale');
      }
    } catch (e) {
      throw Exception('Failed to create sale: $e');
    }
  }

  Future<void> updateSale(int id, Map<String, dynamic> updatedData) async {
    try {
      final response = await _apiService.patch('Sales/UpdateSale/$id', updatedData);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to update sale');
      }
    } catch (e) {
      throw Exception('Failed to update sale: $e');
    }
  }

  Future<void> deleteSale(int id) async {
    try {
      final response = await _apiService.delete('Sales/DeleteSale/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete sale');
      }
    } catch (e) {
      throw Exception('Failed to delete sale: $e');
    }
  }
}
