import 'package:flutter/material.dart';

class InventoryItem {
  final String name;
  final String category;
  final String date;
  final String warehouse;
  final double stockRatio;
  final bool isLowStock;

  InventoryItem({
    required this.name,
    required this.category,
    required this.date,
    required this.warehouse,
    required this.stockRatio,
    required this.isLowStock,
  });
}

class InventoryViewModel extends ChangeNotifier {
  final List<InventoryItem> _items = [];
  final List<InventoryItem> _filteredItems = [];

  String _searchQuery = '';

  List<InventoryItem> get items =>
      _searchQuery.isEmpty ? _items : _filteredItems;

  int get totalItems => _items.length;

  int get lowStockCount => _items.where((e) => e.isLowStock).length;

  int get categoriesCount => _items.map((e) => e.category).toSet().length;

  void addItem(InventoryItem item) {
    _items.add(item);
    _applyFilter();
    notifyListeners();
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    _applyFilter();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredItems.clear();
    } else {
      _filteredItems
        ..clear()
        ..addAll(
          _items.where(
            (item) =>
                item.name.toLowerCase().contains(_searchQuery) ||
                item.category.toLowerCase().contains(_searchQuery),
          ),
        );
    }
  }
}
