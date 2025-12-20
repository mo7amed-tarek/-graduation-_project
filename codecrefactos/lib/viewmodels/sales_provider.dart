import 'package:flutter/foundation.dart';
import 'sale_model.dart';
import 'purchase_model.dart';

class SalesProvider extends ChangeNotifier {
  final List<SaleModel> _sales = [];
  final List<Purchase> _purchases = [];

  final List<SaleModel> _filteredSales = [];

  final List<Purchase> _filteredPurchases = [];

  String _searchQuery = '';
  String _purchaseSearchQuery = '';

  List<SaleModel> get sales => List.unmodifiable(_sales);
  List<Purchase> get purchases => List.unmodifiable(_purchases);

  List<SaleModel> get filteredSales =>
      List.unmodifiable(_filteredSales.isEmpty && _searchQuery.isEmpty ? _sales : _filteredSales);

  List<Purchase> get filteredPurchases =>
      List.unmodifiable(_filteredPurchases.isEmpty && _purchaseSearchQuery.isEmpty ? _purchases : _filteredPurchases);

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applyFilter();
  }

  void setPurchaseSearchQuery(String query) {
    _purchaseSearchQuery = query.trim();
    _applyPurchaseFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredSales
        ..clear()
        ..addAll(_sales);
      notifyListeners();
      return;
    }

    final q = _searchQuery.toLowerCase();
    _filteredSales
      ..clear()
      ..addAll(_sales.where((sale) {
        try {
          final customer = (sale as dynamic).customerName;
          if (customer == null) return false;
          return customer.toString().toLowerCase().contains(q);
        } catch (_) {
          return false;
        }
      }));
    notifyListeners();
  }


  void _applyPurchaseFilter() {
    if (_purchaseSearchQuery.isEmpty) {
      _filteredPurchases
        ..clear()
        ..addAll(_purchases);
      notifyListeners();
      return;
    }

    final q = _purchaseSearchQuery.toLowerCase();
    _filteredPurchases
      ..clear()
      ..addAll(_purchases.where((purchase) {
        try {
          // Try multiple possible name-like fields on Purchase model.
          final dynamic p = purchase as dynamic;
          final candidate = (p.supplierName ?? p.supplier ?? p.name ?? p.title)?.toString();
          if (candidate == null) return false;
          return candidate.toLowerCase().contains(q);
        } catch (_) {
          // If none of the fields exist or error occurs, exclude the item.
          return false;
        }
      }));
    notifyListeners();
  }

  void addSale(SaleModel sale) {
    _sales.add(sale);
    _applyFilter(); // re-apply to keep filtered view in sync
  }

  void updateSale(int index, SaleModel sale) {
    if (index >= 0 && index < _sales.length) {
      _sales[index] = sale;
      _applyFilter();
    }
  }

  void removeSaleAt(int index) {
    if (index >= 0 && index < _sales.length) {
      _sales.removeAt(index);
      _applyFilter();
    }
  }

  void clear() {
    _sales.clear();
    _applyFilter();
  }

  void removeSale(SaleModel sale) {
    final idx = _sales.indexWhere((s) => identical(s, sale) || s == sale);
    if (idx != -1) {
      _sales.removeAt(idx);
      _applyFilter();
    }
  }

  void updateSaleByModel(SaleModel oldSale, SaleModel newSale) {
    final idx = _sales.indexWhere((s) => identical(s, oldSale) || s == oldSale);
    if (idx != -1) {
      _sales[idx] = newSale;
      _applyFilter();
    }
  }

  void addPurchase(Purchase purchase) {
    _purchases.add(purchase);
    _applyPurchaseFilter();
  }

  void updatePurchase(int index, Purchase purchase) {
    if (index >= 0 && index < _purchases.length) {
      _purchases[index] = purchase;
      _applyPurchaseFilter();
    }
  }

  void removePurchaseAt(int index) {
    if (index >= 0 && index < _purchases.length) {
      _purchases.removeAt(index);
      _applyPurchaseFilter();
    }
  }

  void clearPurchases() {
    _purchases.clear();
    _applyPurchaseFilter();
  }

  void removePurchase(Purchase purchase) {
    final idx = _purchases.indexWhere((p) => identical(p, purchase) || p == purchase);
    if (idx != -1) {
      _purchases.removeAt(idx);
      _applyPurchaseFilter();
    }
  }

  void updatePurchaseByModel(Purchase oldPurchase, Purchase newPurchase) {
    final idx = _purchases.indexWhere((p) => identical(p, oldPurchase) || p == oldPurchase);
    if (idx != -1) {
      _purchases[idx] = newPurchase;
      _applyPurchaseFilter();
    }
  }
}
