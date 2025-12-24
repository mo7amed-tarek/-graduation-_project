class SaleModel {
  final String invoiceNumber;
  final String customerName;
  final String category;
  final String product;
  final String employee;
  final String amount;
  final String status;

  SaleModel({
    required this.invoiceNumber,
    required this.customerName,
    required this.category,
    required this.product,
    required this.employee,
    required this.amount,
    this.status = 'Pending',
  });

  SaleModel copyWith({
    String? invoiceNumber,
    String? customerName,
    String? category,
    String? product,
    String? employee,
    String? amount,
    String? status,
  }) {
    return SaleModel(
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      category: category ?? this.category,
      product: product ?? this.product,
      employee: employee ?? this.employee,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }
}
