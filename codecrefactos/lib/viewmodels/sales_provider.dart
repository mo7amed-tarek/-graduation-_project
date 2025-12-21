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

  List<SaleModel> get filteredSales => List.unmodifiable(
    _filteredSales.isEmpty && _searchQuery.isEmpty ? _sales : _filteredSales,
  );

  List<Purchase> get filteredPurchases => List.unmodifiable(
    _filteredPurchases.isEmpty && _purchaseSearchQuery.isEmpty
        ? _purchases
        : _filteredPurchases,
  );

  double get totalSalesAmount {
    return _sales.fold(0.0, (sum, sale) {
      final value = double.tryParse(
        sale.amount.replaceAll(',', '').replaceAll('\$', ''),
      );
      return sum + (value ?? 0);
    });
  }

  int get completedSalesCount {
    return _sales
        .where((sale) => sale.category.toLowerCase() == 'completed')
        .length;
  }

  /// ⏳ PENDING SALES COUNT
  int get pendingSalesCount {
    return _sales
        .where((sale) => sale.category.toLowerCase() == 'pending')
        .length;
  }

  double get totalPurchasesAmount {
    return _purchases.fold(0.0, (sum, purchase) {
      final value = double.tryParse(
        purchase.amount.replaceAll(',', '').replaceAll('\$', ''),
      );
      return sum + (value ?? 0);
    });
  }

  int get receivedPurchasesCount {
    return _purchases.where((p) => p.status.toLowerCase() == 'received').length;
  }

  int get pendingPurchasesCount {
    return _purchases.where((p) => p.status.toLowerCase() == 'pending').length;
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applySalesFilter();
  }

  void setPurchaseSearchQuery(String query) {
    _purchaseSearchQuery = query.trim();
    _applyPurchaseFilter();
  }

  void _applySalesFilter() {
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
      ..addAll(
        _sales.where((sale) => sale.customerName.toLowerCase().contains(q)),
      );

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
      ..addAll(
        _purchases.where((purchase) {
          try {
            final dynamic p = purchase;
            final candidate =
                (p.supplierName ?? p.supplier ?? p.name ?? p.title)?.toString();
            if (candidate == null) return false;
            return candidate.toLowerCase().contains(q);
          } catch (_) {
            return false;
          }
        }),
      );

    notifyListeners();
  }

  void addSale(SaleModel sale) {
    _sales.add(sale);
    _applySalesFilter();
  }

  void updateSale(int index, SaleModel sale) {
    if (index >= 0 && index < _sales.length) {
      _sales[index] = sale;
      _applySalesFilter();
    }
  }

  void updateSaleByModel(SaleModel oldSale, SaleModel newSale) {
    final idx = _sales.indexWhere((s) => identical(s, oldSale) || s == oldSale);
    if (idx != -1) {
      _sales[idx] = newSale;
      _applySalesFilter();
    }
  }

  void removeSaleAt(int index) {
    if (index >= 0 && index < _sales.length) {
      _sales.removeAt(index);
      _applySalesFilter();
    }
  }

  void removeSale(SaleModel sale) {
    final idx = _sales.indexWhere((s) => identical(s, sale) || s == sale);
    if (idx != -1) {
      _sales.removeAt(idx);
      _applySalesFilter();
    }
  }

  void clearSales() {
    _sales.clear();
    _applySalesFilter();
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

  void updatePurchaseByModel(Purchase oldPurchase, Purchase newPurchase) {
    final idx = _purchases.indexWhere(
      (p) => identical(p, oldPurchase) || p == oldPurchase,
    );
    if (idx != -1) {
      _purchases[idx] = newPurchase;
      _applyPurchaseFilter();
    }
  }

  void removePurchaseAt(int index) {
    if (index >= 0 && index < _purchases.length) {
      _purchases.removeAt(index);
      _applyPurchaseFilter();
    }
  }

  void removePurchase(Purchase purchase) {
    final idx = _purchases.indexWhere(
      (p) => identical(p, purchase) || p == purchase,
    );
    if (idx != -1) {
      _purchases.removeAt(idx);
      _applyPurchaseFilter();
    }
  }

  void clearPurchases() {
    _purchases.clear();
    _applyPurchaseFilter();
  }
}
