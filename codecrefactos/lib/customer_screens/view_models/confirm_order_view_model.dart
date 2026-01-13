import 'package:flutter/material.dart';

enum ShippingMethod { normal, fast }

class ConfirmOrderVM extends ChangeNotifier {
  ShippingMethod selectedMethod = ShippingMethod.normal;

  double get shippingCost {
    switch (selectedMethod) {
      case ShippingMethod.fast:
        return 70;
      case ShippingMethod.normal:
        return 30;
    }
  }

  void selectMethod(ShippingMethod method) {
    selectedMethod = method;
    notifyListeners();
  }
}
