class SaleModel {
  final int? id;
  final String customerName;
  final String? employeeName;
  final int? employeeId;
  final String? productName;
  final int? productId;
  final String? categoryName;
  final int quantity;
  final double? price;
  final double? totalAmount;
  final String status;

  SaleModel({
    this.id,
    required this.customerName,
    this.employeeName,
    this.employeeId,
    this.productName,
    this.productId,
    this.categoryName,
    required this.quantity,
    this.price,
    this.totalAmount,
    this.status = 'Pending',
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      customerName: json['customerName'] ?? '',
      employeeName: json['employeeName'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName,
      "employeeId": employeeId,
      "productId": productId,
      "quantity": quantity,
      "status": status,
    };
  }

  SaleModel copyWith({
    int? id,
    String? customerName,
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
    return SaleModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
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
