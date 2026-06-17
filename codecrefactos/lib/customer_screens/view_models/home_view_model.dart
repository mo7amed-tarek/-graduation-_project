import 'package:codecrefactos/apiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class HomeVM extends ChangeNotifier {
  final ApiService apiService;

  HomeVM(this.apiService);

  final List<Product> _products = [];
  List<Product> get products => _products;

  int _pageIndex = 1;
  final int _pageSize = 50; // بنطلب أكبر عدد - السيرفر بيتجاهله وبيرجع 10

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

      final responseBody = response.data as Map<String, dynamic>;
      final data = responseBody['data'] as List;

      final int serverPageSize =
          (responseBody['pageSize'] as num?)?.toInt() ?? 10;

      final newProducts = data.map((e) => Product.fromJson(e)).toList();

      if (newProducts.length < serverPageSize) {
        hasMore = false;
      }

      _products.addAll(newProducts);
      _pageIndex++;

      debugPrint(
        " Page ${_pageIndex - 1}: got ${newProducts.length} | "
        "serverPageSize=$serverPageSize | hasMore=$hasMore | total=${_products.length}",
      );
    } catch (e) {
      debugPrint("fetchProducts ERROR: $e");
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }

    if (hasMore) {
      _fetchAllRemainingPages();
    }
  }

  Future<void> _fetchAllRemainingPages() async {
    while (hasMore && !isLoading) {
      try {
        isLoadingMore = true;
        notifyListeners();

        final response = await apiService.get(
          "Product/All_Products",
          queryParameters: {"pageIndex": _pageIndex, "pageSize": _pageSize},
        );

        final responseBody = response.data as Map<String, dynamic>;
        final data = responseBody['data'] as List;

        final int serverPageSize =
            (responseBody['pageSize'] as num?)?.toInt() ?? 10;

        final newProducts = data.map((e) => Product.fromJson(e)).toList();

        if (newProducts.length < serverPageSize) {
          hasMore = false;
        }

        _products.addAll(newProducts);
        _pageIndex++;

        debugPrint(
          " BG Page ${_pageIndex - 1}: got ${newProducts.length} | "
          "serverPageSize=$serverPageSize | hasMore=$hasMore | total=${_products.length}",
        );
      } catch (e) {
        debugPrint("_fetchAllRemainingPages ERROR: $e");
        break;
      } finally {
        isLoadingMore = false;
        notifyListeners();
      }
    }
    debugPrint(" All pages fetched! Total products: ${_products.length}");
  }

  Future<void> refreshStock() async {
    try {
      final int totalFetched = _products.length;
      final int pagesToFetch = totalFetched > 0
          ? (totalFetched / 10).ceil()
          : 1;

      final List<Product> updatedProducts = [];

      for (int page = 1; page <= pagesToFetch; page++) {
        final response = await apiService.get(
          "Product/All_Products",
          queryParameters: {"pageIndex": page, "pageSize": _pageSize},
        );
        final data = response.data['data'] as List;
        updatedProducts.addAll(data.map((e) => Product.fromJson(e)));
      }

      for (int i = 0; i < _products.length; i++) {
        final updated = updatedProducts.firstWhere(
          (p) => p.id == _products[i].id,
          orElse: () => _products[i],
        );
        _products[i] = updated;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("refreshStock ERROR: $e");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
