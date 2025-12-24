import 'package:codecrefactos/views/login_screen.dart';
import 'package:codecrefactos/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../viewmodels/EmployeeModel.dart';
import 'sales/viewmodels/SalesData.dart';
import '../widgets/appbar.dart';
import '../widgets/employee_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
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
              ////////////////////////////////////////////////
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      toptext: ' Total Employees',
                      number: "48",
                      imagepath: 'assets/employyy.png',
                      bottomtext: "+12% from last month",
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: CustomCard(
                      toptext: ' Total Sales',
                      number: "48",
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
                      toptext: ' Total Purchases',
                      number: "48",
                      imagepath: 'assets/purchases.png',
                      bottomtext: "+12% from last month",
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: CustomCard(
                      toptext: ' Total Inventory',
                      number: "48",
                      imagepath: 'assets/inventory.png',
                      bottomtext: "+12% from last month",
                    ),
                  ),
                ],
              ),
              Gap(10.h),
              Container(
                height: 285.h,
                width: 420.w,
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
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelStyle: TextStyle(fontSize: 12.sp),
                            majorGridLines: MajorGridLines(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 140000,
                            interval: 35000,
                            labelStyle: TextStyle(fontSize: 12.sp),
                          ),
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries>[
                            ColumnSeries<SalesData, String>(
                              name: 'Sales',
                              width: 0.5.w,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                              dataSource: [
                                SalesData(month: 'January', value: 65000),
                                SalesData(month: 'February', value: 78000),
                                SalesData(month: 'March', value: 120000),
                              ],
                              xValueMapper: (data, _) => data.month,
                              yValueMapper: (data, _) => data.value,
                              color: Color(0xFF4285F4),
                            ),

                            ColumnSeries<SalesData, String>(
                              name: 'Purchases',
                              width: 0.5.w,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                              dataSource: [
                                SalesData(month: 'January', value: 35000),
                                SalesData(month: 'February', value: 48000),
                                SalesData(month: 'March', value: 78000),
                              ],
                              xValueMapper: (data, _) => data.month,
                              yValueMapper: (data, _) => data.value,
                              color: Color(0xFFFF9800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(10),
              Container(
                height: 200.h,
                width: 420.w,
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
                      Gap(20),
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
