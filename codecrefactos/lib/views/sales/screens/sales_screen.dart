import 'package:codecrefactos/views/sales/widget/Custom_SalesCard.dart';
import 'package:codecrefactos/views/sales/widget/search_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../widgets/appbar.dart';
import '../widget/Custom_Total_cart.dart';
import '../widget/custom_SummaryCard.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        onAdd: () {
          // Handle add action
        },
        onLogout: () {
          // Handle logout action
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sales Management",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400),
              ),
              Text(
                "View and manage all sales",
                style: TextStyle(
                  color: Color(0xff717182),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(10.h),
              CustomTotalCart(
                total: "Total Sales",
                price: "\$48,900",
                imagePath: 'assets/mark.png',
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomSummarycard(
                      title: 'Completed Sales',
                      value: '4',
                      valueColor: Color(0xff00A63E),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: CustomSummarycard(
                      title: 'Pending Sales',
                      value: '1',
                      valueColor: Color(0xffF54900),
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              SearchFilter(),
              Gap(16.h),
              CustomSalescard(date: "2025/10/1",
                name: "John Smith",
                company: "Tech Corp",
                price: "\$12,000",
                status: "Completed",)
              







            ],
          ),
        ),
      ),
    );
  }
}
