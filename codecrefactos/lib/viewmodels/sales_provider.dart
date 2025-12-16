import 'package:flutter/foundation.dart';
import 'sale_model.dart';
import 'purchase_model.dart';

class SalesProvider extends ChangeNotifier {
  final List<SaleModel> _sales = [];
  final List<Purchase> _purchases = []; // added purchases list

  List<SaleModel> get sales => List.unmodifiable(_sales);
  List<Purchase> get purchases => List.unmodifiable(_purchases); // getter for purchases

  void addSale(SaleModel sale) {
    _sales.add(sale);
    notifyListeners();
  }

  void updateSale(int index, SaleModel sale) {
    if (index >= 0 && index < _sales.length) {
      _sales[index] = sale;
      notifyListeners();
    }
  }

  void removeSaleAt(int index) {
    if (index >= 0 && index < _sales.length) {
      _sales.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _sales.clear();
    notifyListeners();
  }

  // Purchases API (mirrors sales API)
  void addPurchase(Purchase purchase) {
    _purchases.add(purchase);
    notifyListeners();
  }

  void updatePurchase(int index, Purchase purchase) {
    if (index >= 0 && index < _purchases.length) {
      _purchases[index] = purchase;
      notifyListeners();
    }
  }

  void removePurchaseAt(int index) {
    if (index >= 0 && index < _purchases.length) {
      _purchases.removeAt(index);
      notifyListeners();
    }
  }

  void clearPurchases() {
    _purchases.clear();
    notifyListeners();
  }
}
