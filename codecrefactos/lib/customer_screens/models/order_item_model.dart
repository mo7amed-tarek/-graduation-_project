class OrderItem {
  final String productName;
  final String pictureUrl;
  final num price;
  final int quantity;

  OrderItem({
    required this.productName,
    required this.pictureUrl,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? '',
      pictureUrl: json['pictureUrl'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productName": productName,
      "pictureUrl": pictureUrl,
      "price": price,
      "quantity": quantity,
    };
  }
}
