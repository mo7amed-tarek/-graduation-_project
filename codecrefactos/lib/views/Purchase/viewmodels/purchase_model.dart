class Purchase {
  final String invoiceNumber;
  final String supplierName;
  final String category;
  final String product;
  final String employee;
  final String amount;
  final String status;

  Purchase({
    required this.invoiceNumber,
    required this.supplierName,
    required this.category,
    required this.product,
    required this.employee,
    required this.amount,
    this.status = 'Pending',
  });

  Purchase copyWith({
    String? invoiceNumber,
    String? supplierName,
    String? category,
    String? product,
    String? employee,
    String? amount,
    String? status,
  }) {
    return Purchase(
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      supplierName: supplierName ?? this.supplierName,
      category: category ?? this.category,
      product: product ?? this.product,
      employee: employee ?? this.employee,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }
}
