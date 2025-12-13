class SaleModel {
  final String customerName;
  final String category;
  final String employee;
  final String amount;

  SaleModel({
    required this.customerName,
    required this.category,
    required this.employee,
    required this.amount,
  });

  SaleModel copyWith({
    String? customerName,
    String? category,
    String? employee,
    String? amount,
  }) {
    return SaleModel(
      customerName: customerName ?? this.customerName,
      category: category ?? this.category,
      employee: employee ?? this.employee,
amount: amount ??this.amount,  );
  }
}
