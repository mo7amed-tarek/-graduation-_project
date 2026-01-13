import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductVM extends ChangeNotifier {
  late Product product;
  int selectedColor = 0;

  ProductVM(this.product);

  void selectColor(int index) {
    selectedColor = index;
    notifyListeners();
  }
}
