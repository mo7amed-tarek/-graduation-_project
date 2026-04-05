class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final String description;
  final List<int> colors;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
    required this.colors,
    required this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    const String baseUrl = "http://store2.runasp.net";

    String imagePath = json['pictureUrl'] ?? '';

    String fullImageUrl = imagePath.startsWith('http')
        ? imagePath
        : baseUrl + imagePath;

    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: fullImageUrl,
      price: (json['price'] ?? 0).toDouble(),
      rating: 4.0,
      description: json['description'] ?? '',
      colors: [0xFF000000],
      categoryName: json['categoryName'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "pictureUrl": image,
      "price": price,
      "description": description,
      "categoryName": categoryName,
    };
  }
}
