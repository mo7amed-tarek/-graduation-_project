import 'package:flutter/material.dart';
import 'package:codecrefactos/apiService.dart';
import '../models/product_model.dart';
import '../models/basket_model.dart';
import '../models/order_model.dart';

class CartVM extends ChangeNotifier {
  final ApiService apiService;

  CartVM(this.apiService) {
    getBasket();
  }

  Basket? _basket;
  bool isLoading = false;

  List<BasketItem> get items => _basket?.items ?? [];
  double get total => _basket?.total ?? 0.0;

  Future<void> getBasket() async {
    if (isLoading) return;
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiService.get("Basket/GetBasket");

      if (response.data != null) {
        _basket = Basket.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("GET BASKET ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    final productId = int.tryParse(product.id) ?? 0;

    // Find existing item quantity
    final existingItem = _basket?.items.where((i) => i.productId == productId).firstOrNull;
    final int newQuantity = (existingItem?.quantity ?? 0) + quantity;

    final requestBody = {
      "productId": productId,
      "productName": product.name,
      "pictureUrl": product.image,
      "price": product.price,
      "quantity": newQuantity
    };

    await _addOrUpdate(requestBody);
  }

  Future<void> increaseQuantity(BasketItem item) async {
    final requestBody = {
      "productId": item.productId,
      "productName": item.productName,
      "pictureUrl": item.pictureUrl,
      "price": item.price,
      "quantity": item.quantity + 1 
    };

    await _addOrUpdate(requestBody);
  }

  Future<void> decreaseQuantity(BasketItem item) async {
    if (item.quantity > 1) {
      final requestBody = {
        "productId": item.productId,
        "productName": item.productName,
        "pictureUrl": item.pictureUrl,
        "price": item.price,
        "quantity": item.quantity - 1 
      };
      await _addOrUpdate(requestBody);
    } else {
      await removeItem(item);
    }
  }

  Future<void> _addOrUpdate(Map<String, dynamic> requestBody) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiService.post(
        "Basket/OpenBasketWithAddOrUpdateItem",
        requestBody,
      );

      if (response.data != null) {
        _basket = Basket.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("ADD/UPDATE BASKET ITEM ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeItem(BasketItem item) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiService.delete("Basket/Deleteitems/${item.productId}");

      if (response.data != null) {
        _basket = Basket.fromJson(response.data);
      } else {
        _basket?.items.removeWhere((i) => i.productId == item.productId);
      }
    } catch (e) {
      debugPrint("REMOVE ITEM ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clear() async {
    try {
      isLoading = true;
      notifyListeners();

      await apiService.delete("Basket/DeleteBasket");
      _basket = null;
    } catch (e) {
      debugPrint("CLEAR BASKET ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderModel?> createOrder({
    required String address,
    required String phone,
    required int deliveryMethodId,
    required String paymentMethod,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiService.createOrder(
        address: address,
        phone: phone,
        deliveryMethodId: deliveryMethodId,
        paymentMethod: paymentMethod,
      );

      if (response.statusCode == 200 && response.data != null) {
        return OrderModel.fromJson(response.data);
      } else {
        debugPrint("CREATE ORDER RETURNED: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("CREATE ORDER ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
