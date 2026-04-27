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

  static int colorNameToInt(String name) {
    switch (name.trim().toLowerCase()) {
      case 'red':
        return 0xFFE53935;
      case 'blue':
        return 0xFF1E88E5;
      case 'green':
        return 0xFF43A047;
      case 'black':
        return 0xFF212121;
      case 'white':
        return 0xFFF5F5F5;
      case 'yellow':
        return 0xFFFDD835;
      case 'orange':
        return 0xFFFB8C00;
      case 'purple':
        return 0xFF8E24AA;
      case 'pink':
        return 0xFFE91E63;
      case 'grey':
      case 'gray':
        return 0xFF757575;
      case 'silver':
        return 0xFFBDBDBD;
      case 'gold':
        return 0xFFFFD700;
      case 'brown':
        return 0xFF6D4C41;
      case 'cyan':
        return 0xFF00ACC1;
      default:
        return 0xFF9E9E9E;
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    const String baseUrl = "http://store2.runasp.net";

    String imagePath = json['pictureUrl'] ?? '';
    String fullImageUrl = imagePath.startsWith('http')
        ? imagePath
        : baseUrl + imagePath;

    final String colorString = json['color'] ?? '';
    final List<int> colorList = colorString.isNotEmpty
        ? colorString.split(',').map((c) => colorNameToInt(c.trim())).toList()
        : [0xFF9E9E9E];

    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: fullImageUrl,
      price: (json['price'] ?? 0).toDouble(),
      rating: 4.0,
      description: json['description'] ?? '',
      colors: colorList,
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
