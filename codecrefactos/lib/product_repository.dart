import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:codecrefactos/apiService.dart';
import 'package:codecrefactos/Inventory%20Management/viewmodels/inventory_viewmodel.dart';

class ProductRepository {
  final ApiService _api = ApiService();

  Future<({List<InventoryItem> items, bool hasMore})> getProducts({
    int pageIndex = 1,
    int pageSize = 5,
    String? sort,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'pageIndex': pageIndex, 
        'pageSize': pageSize
      };
      if (sort != null) {
        queryParams['Sort'] = sort;
      }
      
      final response = await _api.get(
        'Product/All_Products',
        queryParameters: queryParams,
      );

      final data = response.data;
      List<InventoryItem> list = [];

      if (data is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner is List) {
          list = inner.map((e) => InventoryItem.fromJson(e)).toList();
        }

        if (inner is Map && inner['items'] is List) {
          list = (inner['items'] as List)
              .map((e) => InventoryItem.fromJson(e))
              .toList();
        }
      } else if (data is List) {
        list = data.map((e) => InventoryItem.fromJson(e)).toList();
      } else {
        debugPrint("⚠️ Unexpected response structure: $data");
      }

      bool hasMore = list.length >= pageSize;
      
      if (data is Map<String, dynamic>) {
        if (data.containsKey('pageSize') && data['pageSize'] is int) {
          int actualPageSize = data['pageSize'];
          if (actualPageSize > 0) {
            hasMore = list.length >= actualPageSize;
          }
        }
      }

      return (items: list, hasMore: hasMore);
    } on DioException catch (e) {
      debugPrint("GET PRODUCTS DioError: ${e.response?.data} | ${e.message}");
      throw Exception("Failed to load products: ${e.message}");
    } catch (e) {
      debugPrint("GET PRODUCTS ERROR: $e");
      throw Exception("Failed to load products");
    }
  }

  Future<int> addProduct(InventoryItem item) async {
    try {
      final response = await _api.post(
        'Product',
        item.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      final data = response.data;
      debugPrint("ADD PRODUCT RESPONSE: $data");

      if (data is Map<String, dynamic>) {
        final id =
            data['data']?['id'] ??
            data['id'] ??
            data['productId'] ??
            data['data']?['productId'];

        if (id != null) return int.tryParse(id.toString()) ?? 0;
      }

      debugPrint("⚠️ Could not extract ID from response: $data");
      return 0;
    } on DioException catch (e) {
      debugPrint("ADD PRODUCT DioError: ${e.response?.data} | ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("ADD PRODUCT ERROR: $e");
      rethrow;
    }
  }

  Future<void> updateProduct(int id, InventoryItem item) async {
    try {
      await _api.patch(
        'Product/$id',
        item.toJson(),
        headers: {'Content-Type': 'application/json'},
      );
    } on DioException catch (e) {
      debugPrint("UPDATE DioError: ${e.response?.data} | ${e.message}");
      throw Exception("Failed to update product: ${e.response?.data}");
    } catch (e) {
      debugPrint("UPDATE ERROR: $e");
      throw Exception("Failed to update product");
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _api.delete('Product/$id');
    } on DioException catch (e) {
      debugPrint("DELETE DioError: ${e.response?.data} | ${e.message}");
      throw Exception("Failed to delete product: ${e.response?.data}");
    } catch (e) {
      debugPrint("DELETE ERROR: $e");
      throw Exception("Failed to delete product");
    }
  }

  Future<void> uploadProductImage(int productId, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await _api.post(
        'Product/upload-image/$productId',
        formData,
        isFormData: true,
      );

      debugPrint("UPLOAD RESPONSE: ${response.data}");
    } on DioException catch (e) {
      debugPrint("UPLOAD DioError: ${e.response?.data} | ${e.message}");
      throw Exception("Failed to upload image: ${e.response?.data}");
    } catch (e) {
      debugPrint("UPLOAD IMAGE ERROR: $e");
      throw Exception("Failed to upload image");
    }
  }
}
