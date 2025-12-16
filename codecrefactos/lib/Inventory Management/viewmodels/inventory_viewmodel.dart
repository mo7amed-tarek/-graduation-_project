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
  List<InventoryItem> get items => _items;

  int get totalItems => _items.length;

  int get lowStockCount => _items.where((e) => e.isLowStock).length;

  int get categoriesCount => _items.map((e) => e.category).toSet().length;

  void addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
