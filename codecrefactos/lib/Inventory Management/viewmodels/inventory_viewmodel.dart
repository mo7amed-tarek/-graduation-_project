import 'package:flutter/material.dart';
import 'package:codecrefactos/product_repository.dart';

class InventoryItem {
  final int? id;
  final String name;
  final String description;
  final String color;
  final String pictureUrl;
  final double price;
  final String categoryName;
  final int? categoryId;
  final int quantity;
  final bool isLowStock;

  InventoryItem({
    this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.pictureUrl,
    required this.price,
    required this.categoryName,
    this.categoryId,
    required this.quantity,
    required this.isLowStock,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    int parseIntSafe(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      return int.tryParse(val.toString()) ?? 0;
    }

    double parseDoubleSafe(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is int) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final qty = parseIntSafe(json['quantity']);

    return InventoryItem(
      id: parseIntSafe(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      pictureUrl: json['pictureUrl']?.toString() ?? '',
      price: parseDoubleSafe(json['price']),
      categoryName: json['categoryName']?.toString() ?? '',
      categoryId: json['categoryId'] != null
          ? parseIntSafe(json['categoryId'])
          : null,
      quantity: qty,
      isLowStock: qty <= 5,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'color': color,
    'pictureUrl': pictureUrl.isNotEmpty ? pictureUrl : 'N/A',
    'price': price,
    'categoryId': categoryId,
    'quantity': quantity,
  };
}

class InventoryViewModel extends ChangeNotifier {
  final ProductRepository _repo = ProductRepository();

  final List<InventoryItem> _items = [];
  final List<InventoryItem> _filteredItems = [];

  String _searchQuery = '';

  int _pageIndex = 1;
  final int _pageSize = 5;

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  int _totalItemsCount = 0;

  String? errorMessage;

  List<InventoryItem> get items =>
      _searchQuery.isEmpty ? _items : _filteredItems;

  int get totalItems => _totalItemsCount > 0 ? _totalItemsCount : _items.length;
  int get lowStockCount => _items.where((e) => e.isLowStock).length;
  int get categoriesCount => _items.map((e) => e.categoryName).toSet().length;

  Future<void> loadItems({bool refresh = false}) async {
    if (refresh) {
      _pageIndex = 1;
      hasMore = true;
      _items.clear();
      _totalItemsCount = 0;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.getProducts(
        pageIndex: _pageIndex,
        pageSize: _pageSize,
      );

      hasMore = result.hasMore;
      _items.addAll(result.items);
      _totalItemsCount = _items.length;
      _applyFilter();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    _pageIndex++;
    notifyListeners();

    try {
      final result = await _repo.getProducts(
        pageIndex: _pageIndex,
        pageSize: _pageSize,
      );

      hasMore = result.hasMore;
      _items.addAll(result.items);
      _totalItemsCount = _items.length;
      _applyFilter();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoadingMore = false;
    notifyListeners();
  }

  Future<int> addItem(InventoryItem item) async {
    final newId = await _repo.addProduct(item);
    await loadItems(refresh: true);
    return newId;
  }

  Future<void> updateItem(InventoryItem item) async {
    if (item.id == null) return;
    await _repo.updateProduct(item.id!, item);
    await loadItems(refresh: true);
  }

  // ✅ بيحذف من الـ API الأول، لو نجح بيحذف من الـ UI بدون loading
  Future<void> deleteItem(InventoryItem item) async {
    if (item.id == null) return;

    try {
      // ✅ الأول: حذف من الـ API
      await _repo.deleteProduct(item.id!);

      // ✅ لو نجح: احذف من الـ list محلياً بدون loading
      _items.remove(item);
      _totalItemsCount = _items.length;
      _applyFilter();
      notifyListeners();
    } catch (e) {
      // ✅ لو فشل: ارمي الـ error للـ UI يتعامل معاه
      rethrow;
    }
  }

  Future<void> uploadImage(int id, String path) async {
    await _repo.uploadProductImage(id, path);
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    _filteredItems
      ..clear()
      ..addAll(
        _items.where(
          (e) =>
              e.name.toLowerCase().contains(_searchQuery) ||
              e.categoryName.toLowerCase().contains(_searchQuery),
        ),
      );
  }
}
