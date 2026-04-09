class BasketItem {
  final int productId;
  final String productName;
  final String pictureUrl;
  final double price;
  final int quantity;

  BasketItem({
    required this.productId,
    required this.productName,
    required this.pictureUrl,
    required this.price,
    required this.quantity,
  });

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      pictureUrl: json['pictureUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "pictureUrl": pictureUrl,
      "price": price,
      "quantity": quantity,
    };
  }
}

class Basket {
  final List<BasketItem> items;
  final int? deliveryMethodId;
  final double? shippingPrice;
  final String? paymentIntentID;
  final String? clientSecret;
  final double total;

  Basket({
    required this.items,
    this.deliveryMethodId,
    this.shippingPrice,
    this.paymentIntentID,
    this.clientSecret,
    required this.total,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<BasketItem> parsedItems =
        itemsList.map((item) => BasketItem.fromJson(item)).toList();

    return Basket(
      items: parsedItems,
      deliveryMethodId: json['deliveryMethodId'],
      shippingPrice: (json['shippingPrice'] ?? 0).toDouble(),
      paymentIntentID: json['paymentIntentID'],
      clientSecret: json['clientSecret'],
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
      "deliveryMethodId": deliveryMethodId,
      "shippingPrice": shippingPrice,
      "paymentIntentID": paymentIntentID,
      "clientSecret": clientSecret,
      "total": total,
    };
  }
}
