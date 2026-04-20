import 'package:flutter/foundation.dart';
import 'sale_model.dart';
import '../api/sale_api.dart';

class SalesProvider extends ChangeNotifier {
  final SaleApi _api = SaleApi();

  List<SaleModel> _sales = [];
  List<SaleModel> _filteredSales = [];
  String _searchQuery = '';

  bool isLoading = false;
  String? errorMessage;

  SalesProvider() {
    fetchSales();
  }

  // Getters
  List<SaleModel> get sales => List.unmodifiable(_sales);

  List<SaleModel> get filteredSales => List.unmodifiable(
        _filteredSales.isEmpty && _searchQuery.isEmpty ? _sales : _filteredSales,
      );

  double get totalSalesAmount {
    return _sales.fold(0.0, (sum, sale) => sum + (sale.totalAmount ?? 0.0));
  }

  int get completedSalesCount =>
      _sales.where((s) => s.status.toLowerCase() == 'completed').length;

  int get pendingSalesCount =>
      _sales.where((s) => s.status.toLowerCase() == 'pending').length;

  Future<void> fetchSales() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _api.getAllSales();
      _sales = data.map((json) => SaleModel.fromJson(json)).toList();
      _applySalesFilter();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applySalesFilter();
  }

  void _applySalesFilter() {
    if (_searchQuery.isEmpty) {
      _filteredSales.clear();
      _filteredSales.addAll(_sales);
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredSales.clear();
      _filteredSales.addAll(
        _sales.where((sale) =>
            sale.customerName.toLowerCase().contains(q) ||
            (sale.productName?.toLowerCase().contains(q) ?? false)),
      );
    }
    notifyListeners();
  }

  Future<void> addSale(SaleModel sale) async {
    try {
      await _api.createSale(sale.toJson());
      await fetchSales();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateSaleByModel(SaleModel oldSale, SaleModel newSale) async {
    if (oldSale.id == null) return;
    try {
      await _api.updateSale(oldSale.id!, newSale.toJson());
      await fetchSales();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeSale(SaleModel sale) async {
    if (sale.id == null) return;
    try {
      await _api.deleteSale(sale.id!);
      await fetchSales();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}