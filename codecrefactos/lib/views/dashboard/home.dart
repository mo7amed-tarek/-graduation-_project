import 'package:codecrefactos/Inventory%20Management/viewmodels/inventory_viewmodel.dart';
import 'package:codecrefactos/employwee_screen/EmployeeModel.dart';
import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:codecrefactos/login_screen/login_screen.dart';
import 'package:codecrefactos/views/Purchase/viewmodels/Purchase_Provider.dart';
import 'package:codecrefactos/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../sales/viewmodels/SalesData.dart';
import '../../widgets/appbar.dart';
import '../../widgets/employee_item.dart';
import '../sales/viewmodels/sales_provider.dart';
import 'package:codecrefactos/views/dashboard/dashboard_provider.dart';
import 'package:codecrefactos/views/dashboard/dashboard_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InventoryViewModel>();
    final salesProvider = context.watch<SalesProvider>();
    final purchasesProvider = context.watch<PurchasesProvider>();
    final employeesProvider = context.watch<EmployeesViewModel>();
    final dashboardProvider = context.watch<DashboardProvider>();

    List<MonthlySalesPurchase> chartData =
        dashboardProvider.dashboardData?.monthlySalesPurchases ?? [];
    if (chartData.isEmpty && dashboardProvider.dashboardData != null) {
      chartData = [
        MonthlySalesPurchase(
          month: 'Total',
          sales: dashboardProvider.dashboardData!.totalSalesAmount,
          purchases: dashboardProvider.dashboardData!.totalPurchasesAmount,
        ),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Appbar(
          showAddButton: false,
          showLogoutButton: true,
          bottonTitle: '',
          onLogout: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0A0A0A),
                ),
              ),
              Text(
                'Welcome to the Company Management System',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff717182),
                ),
              ),
              Gap(10.h),

              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      toptext: 'Total Employees',
                      number:
                          dashboardProvider.dashboardData?.totalEmployees
                              .toString() ??
                          '0',
                      imagepath: 'assets/employyy.png',
                      bottomtext: "+12% from last month",
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: CustomCard(
                      toptext: 'Total Sales',
                      number:
                          "\$${(dashboardProvider.dashboardData?.totalSalesAmount ?? 0).toStringAsFixed(2)}",
                      imagepath: 'assets/sales.png',
                      bottomtext: "+12% from last month",
                    ),
                  ),
                ],
              ),
              Gap(10.h),

              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      toptext: 'Total Purchases',
                      number:
                          "\$${(dashboardProvider.dashboardData?.totalPurchasesAmount ?? 0).toStringAsFixed(2)}",
                      imagepath: 'assets/purchases.png',
                      bottomtext: "+12% from last month",
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: CustomCard(
                      toptext: 'Total Inventory',
                      number:
                          dashboardProvider.dashboardData?.totalProducts
                              .toString() ??
                          '0',
                      imagepath: 'assets/inventory.png',
                      bottomtext: "+12% from last month",
                    ),
                  ),
                ],
              ),
              Gap(10.h),

              Container(
                height: 285.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Sales & Purchases',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff0A0A0A),
                        ),
                      ),
                      Gap(10.h),
                      Expanded(
                        child: dashboardProvider.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : dashboardProvider.errorMessage != null
                            ? Center(
                                child: Text(
                                  dashboardProvider.errorMessage!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  labelStyle: TextStyle(fontSize: 12.sp),
                                  majorGridLines: MajorGridLines(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum: 0,
                                  labelStyle: TextStyle(fontSize: 12.sp),
                                ),
                                legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                ),
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <CartesianSeries>[
                                  ColumnSeries<MonthlySalesPurchase, String>(
                                    name: 'Sales',
                                    width: 0.3,
                                    spacing: 0.2,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                    dataSource: chartData,
                                    xValueMapper: (data, _) => data.month,
                                    yValueMapper: (data, _) => data.sales,
                                    color: Color(0xFF4285F4),
                                  ),
                                  ColumnSeries<MonthlySalesPurchase, String>(
                                    name: 'Purchases',
                                    width: 0.3,
                                    spacing: 0.2,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                    dataSource: chartData,
                                    xValueMapper: (data, _) => data.month,
                                    yValueMapper: (data, _) => data.purchases,
                                    color: Color(0xFFFF9800),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(10.h),

              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Performing Employees',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff0A0A0A),
                        ),
                      ),
                      Gap(6.h),
                      EmployeeItem(
                        employee: EmployeeModel(
                          imagePath: "assets/rat1.png",
                          name: "John Smith",
                          salesText: "\$40,230 in sales",
                          percent: 0.85,
                          percentText: "85%",
                        ),
                      ),
                      Gap(20.h),
                      EmployeeItem(
                        employee: EmployeeModel(
                          imagePath: "assets/rat2.png",
                          name: "Sarah Johnson",
                          salesText: "\$38,540 in sales",
                          percent: 0.58,
                          percentText: "58%",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
