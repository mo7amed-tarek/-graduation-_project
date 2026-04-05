import 'package:dio/dio.dart';
import 'package:codecrefactos/apiService.dart';
import 'package:codecrefactos/Inventory%20Management/viewmodels/inventory_viewmodel.dart';

class ProductRepository {
  final ApiService _api = ApiService();

  Future<List<InventoryItem>> getProducts({
    int pageIndex = 1,
    int pageSize = 5,
  }) async {
    try {
      final response = await _api.get(
        'Product/All_Products',
        queryParameters: {'pageIndex': pageIndex, 'pageSize': pageSize},
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        final list = data['data'];

        if (list is List) {
          return list.map((e) => InventoryItem.fromJson(e)).toList();
        }
      }

      return [];
    } catch (e) {
      print("GET PRODUCTS ERROR: $e");
      throw Exception("Failed to load products");
    }
  }

  Future<int> addProduct(InventoryItem item) async {
    try {
      final response = await _api.post('Product', item.toJson());

      final data = response.data;

      if (data is Map<String, dynamic>) {
        if (data['data'] != null && data['data']['id'] != null) {
          return data['data']['id'];
        }

        if (data['id'] != null) {
          return data['id'];
        }
      }

      return 0;
    } catch (e) {
      print("ADD PRODUCT ERROR: $e");
      rethrow;
    }
  }

  Future<void> updateProduct(int id, InventoryItem item) async {
    try {
      await _api.patch('Product/$id', item.toJson());
    } catch (e) {
      print("UPDATE ERROR: $e");
      throw Exception("Failed to update product");
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _api.delete('Product/$id');
    } catch (e) {
      print("DELETE ERROR: $e");
      throw Exception("Failed to delete product");
    }
  }

  // ✅ FIX HERE (image → file)
  Future<void> uploadProductImage(int productId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          // ✅ مهم
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await _api.post(
        'Product/upload-image/$productId',
        formData,
        isFormData: true,
      );

      print("UPLOAD RESPONSE: ${response.data}");
    } catch (e) {
      print("UPLOAD IMAGE ERROR: $e");
      throw Exception("Failed to upload image");
    }
  }
}
