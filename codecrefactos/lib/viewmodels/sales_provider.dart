import 'package:flutter/foundation.dart';
import 'sale_model.dart';

class SalesProvider extends ChangeNotifier {
  final List<SaleModel> _sales = [];

  List<SaleModel> get sales => List.unmodifiable(_sales);

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
}

