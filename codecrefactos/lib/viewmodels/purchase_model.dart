class Purchase {
  final String id;
  final String supplierName;
  final String category;
  final int quantity;
  final double amount;
  final String employee;
  final DateTime date;
  final String status;

  Purchase({
    required this.id,
    required this.supplierName,
    required this.category,
    required this.quantity,
    required this.amount,
    required this.employee,
    required this.date,
    this.status = "Completed",
  });

  Purchase copyWith({
    String? supplierName,
    String? category,
    int? quantity,
    double? amount,
    String? employee,
    DateTime? date,
    String? status,
  }) {
    return Purchase(
      id: id,
      supplierName: supplierName ?? this.supplierName,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      employee: employee ?? this.employee,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }}