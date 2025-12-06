import 'package:codecrefactos/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../widgets/appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbar(),
      ),
      body: Padding(
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
                    toptext: ' Total Employees',
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
                    toptext: ' Total Employees',
                    number: "48",
                    imagepath: 'assets/purchases.png',
                    bottomtext: "+12% from last month",
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: CustomCard(
                    toptext: ' Total Employees',
                    number: "48",
                    imagepath: 'assets/inventory.png',
                    bottomtext: "+12% from last month",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
