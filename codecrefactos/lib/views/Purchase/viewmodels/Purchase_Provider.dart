import 'package:flutter/foundation.dart';
import 'purchase_model.dart';
import '../api/purchase_api.dart';

class PurchasesProvider extends ChangeNotifier {
  final PurchaseApi _api = PurchaseApi();

  List<Purchase> _purchases = [];
  List<Purchase> _filteredPurchases = [];
  String _purchaseSearchQuery = '';

  bool isLoading = false;
  String? errorMessage;

  PurchasesProvider() {
    fetchPurchases();
  }

  List<Purchase> get purchases => List.unmodifiable(_purchases);

  List<Purchase> get filteredPurchases => List.unmodifiable(
        _filteredPurchases.isEmpty && _purchaseSearchQuery.isEmpty
            ? _purchases
            : _filteredPurchases,
      );

  double get totalPurchasesAmount {
    return _purchases.fold(0.0, (sum, purchase) => sum + (purchase.totalAmount ?? 0.0));
  }

  int get completedPurchasesCount =>
      _purchases.where((p) => p.status.toLowerCase() == 'completed' || p.status.toLowerCase() == 'received').length;

  int get pendingPurchasesCount =>
      _purchases.where((p) => p.status.toLowerCase() == 'pending').length;

  Future<void> fetchPurchases() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _api.getAllPurchases();
      _purchases = data.map((json) => Purchase.fromJson(json)).toList();
      _applyPurchaseFilter();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

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
            (p.productName?.toLowerCase().contains(q) ?? false)));
    }
    notifyListeners();
  }

  Future<void> addPurchase(Purchase purchase) async {
    try {
      await _api.createPurchase(purchase.toJson());
      await fetchPurchases();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePurchaseByModel(Purchase oldPurchase, Purchase newPurchase) async {
    if (oldPurchase.id == null) return;
    try {
      await _api.updatePurchase(oldPurchase.id!, newPurchase.toJson());
      await fetchPurchases();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> removePurchase(Purchase purchase) async {
    if (purchase.id == null) return;
    try {
      await _api.deletePurchase(purchase.id!);
      await fetchPurchases();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}