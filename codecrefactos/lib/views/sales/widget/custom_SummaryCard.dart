
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomSummarycard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const CustomSummarycard({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style:  TextStyle(color: Color(0xff717182), fontSize: 14.sp)),
             Gap(6.h),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}