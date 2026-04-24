class Purchase {
  final int? id;
  final String supplierName;
  final String? employeeName;
  final int? employeeId;
  final String? productName;
  final int? productId;
  final String? categoryName;
  final int quantity;
  final double? price;
  final double? totalAmount;
  final String status;

  Purchase({
    this.id,
    required this.supplierName,
    this.employeeName,
    this.employeeId,
    this.productName,
    this.productId,
    this.categoryName,
    required this.quantity,
    this.price,
    this.totalAmount,
    this.status = 'PendingOrder',
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      supplierName: json['supplierName'] ?? '',
      employeeName: json['employeeName'],
      employeeId: json['employeeId'],
      productId: json['productId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'PendingOrder',
    );
  }

  static int _statusToInt(String s) {
    switch (s.toLowerCase()) {
      case 'completed':
      case 'completedorder':
      case 'received':
        return 1;
      case 'cancelled':
      case 'canceled':
        return 2;
      default:
        return 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "supplierName": supplierName,
      if (employeeId != null) "employeeId": employeeId,
      if (productId != null) "productId": productId,
      "quantity": quantity,
      "price": price,
      "status": status,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "dto": {
        "supplierName": supplierName,
        "employeeId": employeeId,
        "productId": productId,
        "quantity": quantity,
        "price": price,
        "status": _statusToInt(status),
      },
    };
  }

  Purchase copyWith({
    int? id,
    String? supplierName,
    String? employeeName,
    int? employeeId,
    String? productName,
    int? productId,
    String? categoryName,
    int? quantity,
    double? price,
    double? totalAmount,
    String? status,
  }) {
    return Purchase(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      employeeName: employeeName ?? this.employeeName,
      employeeId: employeeId ?? this.employeeId,
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      categoryName: categoryName ?? this.categoryName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}
