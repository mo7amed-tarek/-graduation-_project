import 'package:flutter/foundation.dart';
import 'purchase_model.dart';

class PurchasesProvider extends ChangeNotifier {
  final List<Purchase> _purchases = [];
  final List<Purchase> _filteredPurchases = [];
  String _purchaseSearchQuery = '';
  int _purchaseInvoiceCounter = 1;

  List<Purchase> get purchases => List.unmodifiable(_purchases);

  List<Purchase> get filteredPurchases => List.unmodifiable(
        _filteredPurchases.isEmpty && _purchaseSearchQuery.isEmpty
            ? _purchases
            : _filteredPurchases,
      );

  String _generatePurchaseInvoiceNumber() {
    final number = _purchaseInvoiceCounter.toString().padLeft(3, '0');
    _purchaseInvoiceCounter++;
    return 'PO$number';
  }

  double get totalPurchasesAmount {
    return _purchases.fold(0.0, (sum, purchase) {
      final value = double.tryParse(
        purchase.amount.replaceAll(',', '').replaceAll('\$', ''),
      );
      return sum + (value ?? 0);
    });
  }

  int get completedPurchasesCount =>
      _purchases.where((p) => p.status.toLowerCase() == 'completed' || p.status.toLowerCase() == 'received').length;

  int get pendingPurchasesCount =>
      _purchases.where((p) => p.status.toLowerCase() == 'pending').length;

  // Actions
  void setPurchaseSearchQuery(String query) {
    _purchaseSearchQuery = query.trim();
    _applyPurchaseFilter();
  }

  void _applyPurchaseFilter() {
    if (_purchaseSearchQuery.isEmpty) {
      _filteredPurchases
        ..clear()
        ..addAll(_purchases);
    } else {
      final q = _purchaseSearchQuery.toLowerCase();
      _filteredPurchases
        ..clear()
        ..addAll(_purchases.where((p) =>
            p.supplierName.toLowerCase().contains(q) ||
            p.invoiceNumber.toLowerCase().contains(q)));
    }
    notifyListeners();
  }

  void addPurchase(Purchase purchase) {
    final newPurchase = Purchase(
      invoiceNumber: _generatePurchaseInvoiceNumber(),
      supplierName: purchase.supplierName,
      category: purchase.category,
      product: purchase.product,
      employee: purchase.employee,
      amount: purchase.amount,
      status: purchase.status,
    );
    _purchases.add(newPurchase);
    _applyPurchaseFilter();
  }

  void updatePurchaseByModel(Purchase oldPurchase, Purchase newPurchase) {
    final idx = _purchases.indexWhere((p) => p.invoiceNumber == oldPurchase.invoiceNumber);
    if (idx != -1) {
      _purchases[idx] = newPurchase.copyWith(invoiceNumber: oldPurchase.invoiceNumber);
      _applyPurchaseFilter();
    }
  }

  void removePurchase(Purchase purchase) {
    _purchases.removeWhere((p) => p.invoiceNumber == purchase.invoiceNumber);
    _applyPurchaseFilter();
  }
}