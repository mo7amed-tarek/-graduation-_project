import 'order_item_model.dart';
import 'delivery_method_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String address;
  final String phone;
  final DeliveryMethod? deliveryMethod;
  final String paymentMethod;
  final String status;
  final String orderDate;
  final num subtotal;
  final num total;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.phone,
    this.deliveryMethod,
    required this.paymentMethod,
    required this.status,
    required this.orderDate,
    required this.subtotal,
    required this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: itemsJson.map((e) => OrderItem.fromJson(e)).toList(),
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      deliveryMethod: json['deliveryMethod'] != null
          ? DeliveryMethod.fromJson(json['deliveryMethod'])
          : null,
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? '',
      orderDate: json['orderDate'] ?? '',
      subtotal: json['subtotal'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "items": items.map((e) => e.toJson()).toList(),
      "address": address,
      "phone": phone,
      "deliveryMethod": deliveryMethod?.toJson(),
      "paymentMethod": paymentMethod,
      "status": status,
      "orderDate": orderDate,
      "subtotal": subtotal,
      "total": total,
    };
  }
}
