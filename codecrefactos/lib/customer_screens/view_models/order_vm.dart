import 'package:flutter/material.dart';

class OrderVM extends ChangeNotifier {
  String payment = 'Visa';
  String shipping = 'Normal';

  void setPayment(String value) {
    payment = value;
    notifyListeners();
  }

  void setShipping(String value) {
    shipping = value;
    notifyListeners();
  }
}
