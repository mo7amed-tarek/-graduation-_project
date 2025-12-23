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

  int _invoiceCounter = 1;

  String _generateInvoiceNumber() {
    final number = _invoiceCounter.toString().padLeft(3, '0');
    _invoiceCounter++;
    return 'SO$number';
  }

  int _purchaseInvoiceCounter = 1;

  String _generatePurchaseInvoiceId() {
    final number = _purchaseInvoiceCounter.toString().padLeft(3, '0');
    _purchaseInvoiceCounter++;
    return 'PO$number';
  }

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

  int get completedSalesCount =>
      _sales.where((s) => s.status.toLowerCase() == 'completed').length;

  int get pendingSalesCount =>
      _sales.where((s) => s.status.toLowerCase() == 'pending').length;

  double get totalPurchasesAmount {
    return _purchases.fold(0.0, (sum, purchase) {
      final value = double.tryParse(
        purchase.amount.replaceAll(',', '').replaceAll('\$', ''),
      );
      return sum + (value ?? 0);
    });
  }

  int get receivedPurchasesCount =>
      _purchases.where((p) => p.status.toLowerCase() == 'received').length;

  int get pendingPurchasesCount =>
      _purchases.where((p) => p.status.toLowerCase() == 'pending').length;

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
        _purchases.where((p) => p.supplierName.toLowerCase().contains(q)),
      );

    notifyListeners();
  }

  void addSale(SaleModel sale) {
    final saleWithInvoice = sale.copyWith(
      invoiceNumber: _generateInvoiceNumber(),
    );

    _sales.add(saleWithInvoice);
    _applySalesFilter();
  }

  void updateSaleByModel(SaleModel oldSale, SaleModel newSale) {
    final idx = _sales.indexWhere((s) => identical(s, oldSale));
    if (idx != -1) {
      _sales[idx] = newSale;
      _applySalesFilter();
    }
  }

  void removeSale(SaleModel sale) {
    _sales.remove(sale);
    _applySalesFilter();
  }

  void addPurchase(Purchase purchase) {
    final purchaseWithId = Purchase(
      id: _generatePurchaseInvoiceId(),
      supplierName: purchase.supplierName,
      category: purchase.category,
      quantity: purchase.quantity,
      amount: purchase.amount,
      employee: purchase.employee,
      date: purchase.date,
      status: purchase.status,
    );

    _purchases.add(purchaseWithId);
    _applyPurchaseFilter();
  }

  void updatePurchaseByModel(Purchase oldPurchase, Purchase newPurchase) {
    final idx = _purchases.indexWhere((p) => identical(p, oldPurchase));
    if (idx != -1) {
      _purchases[idx] = newPurchase;
      _applyPurchaseFilter();
    }
  }

  void removePurchase(Purchase purchase) {
    _purchases.remove(purchase);
    _applyPurchaseFilter();
  }
}

class SalesData {
  final String month;
  final double value;

  SalesData({required this.month, required this.value});
}
