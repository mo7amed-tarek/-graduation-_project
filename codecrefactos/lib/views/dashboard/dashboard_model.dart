class DashboardModel {
  final int totalEmployees;
  final double totalSalesAmount;
  final int completedSalesCount;
  final int pendingSalesCount;
  final double totalPurchasesAmount;
  final int receivedOrdersCount;
  final int pendingOrdersCount;
  final int totalProducts;
  final int lowStockProducts;
  final List<MonthlySalesPurchase> monthlySalesPurchases;
  final String topSalesEmployee;

  DashboardModel({
    required this.totalEmployees,
    required this.totalSalesAmount,
    required this.completedSalesCount,
    required this.pendingSalesCount,
    required this.totalPurchasesAmount,
    required this.receivedOrdersCount,
    required this.pendingOrdersCount,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.monthlySalesPurchases,
    required this.topSalesEmployee,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalEmployees: json['totalEmployees'] ?? 0,
      totalSalesAmount: (json['totalSalesAmount'] ?? 0).toDouble(),
      completedSalesCount: json['completedSalesCount'] ?? 0,
      pendingSalesCount: json['pendingSalesCount'] ?? 0,
      totalPurchasesAmount: (json['totalPurchasesAmount'] ?? 0).toDouble(),
      receivedOrdersCount: json['receivedOrdersCount'] ?? 0,
      pendingOrdersCount: json['pendingOrdersCount'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      lowStockProducts: json['lowStockProducts'] ?? 0,
      topSalesEmployee: json['topSalesEmployee'] ?? '',
      monthlySalesPurchases: (json['monthlySalesPurchases'] as List?)
              ?.map((e) => MonthlySalesPurchase.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MonthlySalesPurchase {
  final String month;
  final double sales;
  final double purchases;

  MonthlySalesPurchase({
    required this.month,
    required this.sales,
    required this.purchases,
  });

  factory MonthlySalesPurchase.fromJson(Map<String, dynamic> json) {
    return MonthlySalesPurchase(
      month: json['month'] ?? '',
      sales: (json['sales'] ?? 0).toDouble(),
      purchases: (json['purchases'] ?? 0).toDouble(),
    );
  }
}
