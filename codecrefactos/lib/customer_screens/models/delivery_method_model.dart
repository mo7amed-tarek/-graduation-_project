class DeliveryMethod {
  final int id;
  final String shortName;
  final String description;
  final String deliveryTime;
  final num price;

  DeliveryMethod({
    required this.id,
    required this.shortName,
    required this.description,
    required this.deliveryTime,
    required this.price,
  });

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) {
    return DeliveryMethod(
      id: json['id'] ?? 0,
      shortName: json['shortName'] ?? '',
      description: json['description'] ?? '',
      deliveryTime: json['deliveryTime'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "shortName": shortName,
      "description": description,
      "deliveryTime": deliveryTime,
      "price": price,
    };
  }
}
