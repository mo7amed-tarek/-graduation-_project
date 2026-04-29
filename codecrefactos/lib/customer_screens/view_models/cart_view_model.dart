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

  Future<String?> addItem(Product product, {int quantity = 1}) async {
    final productId = int.tryParse(product.id) ?? 0;

    if (product.isOutOfStock) {
      return 'Sorry, this product is out of stock';
    }

    final existingItem = _basket?.items
        .where((i) => i.productId == productId)
        .firstOrNull;
    final int currentCartQty = existingItem?.quantity ?? 0;

    if (currentCartQty + quantity > product.quantity) {
      final int remaining = product.quantity - currentCartQty;
      if (remaining <= 0) {
        return 'You already have the maximum available quantity in your cart';
      }
      return 'Only $remaining more item(s) can be added (${product.quantity} in stock)';
    }

    final int newQuantity = currentCartQty + quantity;
    final requestBody = {
      "productId": productId,
      "productName": product.name,
      "pictureUrl": product.image,
      "price": product.price,
      "quantity": newQuantity,
    };

    await _addOrUpdate(requestBody);
    return null;
  }

  Future<String?> increaseQuantity(
    BasketItem item, {
    required int stockQuantity,
  }) async {
    if (item.quantity >= stockQuantity) {
      return 'Maximum available quantity is $stockQuantity';
    }

    final requestBody = {
      "productId": item.productId,
      "productName": item.productName,
      "pictureUrl": item.pictureUrl,
      "price": item.price,
      "quantity": item.quantity + 1,
    };

    await _addOrUpdate(requestBody);
    return null;
  }

  Future<void> decreaseQuantity(BasketItem item) async {
    if (item.quantity > 1) {
      final requestBody = {
        "productId": item.productId,
        "productName": item.productName,
        "pictureUrl": item.pictureUrl,
        "price": item.price,
        "quantity": item.quantity - 1,
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

      final response = await apiService.delete(
        "Basket/Deleteitems/${item.productId}",
      );

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

  Future<(OrderModel?, String?)> createOrder({
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
        return (OrderModel.fromJson(response.data), null);
      } else {
        return (null, 'Failed to create order, please try again.');
      }
    } catch (e) {
      debugPrint("CREATE ORDER ERROR: $e");
      final errorMsg = _extractApiError(e);
      return (null, errorMsg);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _extractApiError(dynamic error) {
    try {
      final dynamic response = (error as dynamic).response;
      if (response != null) {
        final data = response.data;
        if (data is Map) {
          // جرب errors map أولاً
          final errors = data['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstValue = errors.values.first;
            if (firstValue is List && firstValue.isNotEmpty) {
              return firstValue.first.toString();
            }
          }

          final title = data['title'];
          if (title != null) return title.toString();
        }
      }
    } catch (_) {}
    return 'Failed to create order, please try again.';
  }
}
