import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../viewmodels/EmployeeModel.dart';

class EmployeeItem extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45.w,
          height: 45.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: ClipOval(
            child: Image.asset(employee.imagePath, fit: BoxFit.cover),
          ),
        ),

        Gap(12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),

              Text(
                employee.salesText,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
              ),

              Gap(6.h),

              LinearPercentIndicator(
                lineHeight: 10.h,
                barRadius: Radius.circular(10.r),
                percent: employee.percent,
                backgroundColor: Colors.grey.shade300,
                linearGradient: LinearGradient(
                  colors: [Color(0xff3c9df4), Color(0xffa855f7)],
                ),
              ),
            ],
          ),
        ),

        Gap(10.h),

        Text(
          employee.percentText,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
