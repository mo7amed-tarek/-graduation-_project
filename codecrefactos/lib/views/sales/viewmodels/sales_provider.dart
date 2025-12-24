import 'package:flutter/foundation.dart';
import 'sale_model.dart';

class SalesProvider extends ChangeNotifier {
  final List<SaleModel> _sales = [];
  final List<SaleModel> _filteredSales = [];
  String _searchQuery = '';
  int _invoiceCounter = 1;

  // Getters
  List<SaleModel> get sales => List.unmodifiable(_sales);

  List<SaleModel> get filteredSales => List.unmodifiable(
    _filteredSales.isEmpty && _searchQuery.isEmpty ? _sales : _filteredSales,
  );

  String _generateInvoiceNumber() {
    final number = _invoiceCounter.toString().padLeft(3, '0');
    _invoiceCounter++;
    return 'SO$number';
  }

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

  // Actions
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
            sale.invoiceNumber.toLowerCase().contains(q)
        ),
      );
    }
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
}