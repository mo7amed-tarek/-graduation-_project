import 'package:codecrefactos/apiService.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class HomeVM extends ChangeNotifier {
  final ApiService apiService;

  HomeVM(this.apiService);

  final List<Product> _products = [];
  List<Product> get products => _products;

  int _pageIndex = 1;
  final int _pageSize = 5;

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (isLoading || isLoadingMore) return;

    if (refresh) {
      _pageIndex = 1;
      _products.clear();
      hasMore = true;
    }

    if (!hasMore) return;

    try {
      if (_pageIndex == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }

      notifyListeners();

      final response = await apiService.get(
        "Product/All_Products",
        queryParameters: {"pageIndex": _pageIndex, "pageSize": _pageSize},
      );

      final data = response.data['data'] as List;

      final newProducts = data.map((e) => Product.fromJson(e)).toList();

      if (newProducts.length < _pageSize) {
        hasMore = false;
      }

      _products.addAll(newProducts);
      _pageIndex++;
    } catch (e) {
      debugPrint("ERROR: $e");
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
