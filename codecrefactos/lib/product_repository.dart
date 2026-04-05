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

      throw Exception("Unexpected response format");
    } catch (e) {
      throw Exception("Failed to add product");
    }
  }

  Future<void> updateProduct(int id, InventoryItem item) async {
    try {
      await _api.patch('Product/$id', item.toJson());
    } catch (e) {
      throw Exception("Failed to update product");
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _api.delete('Product/$id');
    } catch (e) {
      throw Exception("Failed to delete product");
    }
  }

  Future<void> uploadProductImage(int productId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imagePath),
      });

      await _api.post(
        'Product/upload-image/$productId',
        formData,
        isFormData: true,
      );
    } catch (e) {
      throw Exception("Failed to upload image");
    }
  }
}
