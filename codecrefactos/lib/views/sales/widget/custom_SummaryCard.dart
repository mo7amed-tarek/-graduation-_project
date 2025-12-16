import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final Widget? trailingImage;

  const CustomSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    this.trailingImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 3,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xff717182),
                    fontSize: 14.sp,
                  ),
                ),
                Gap(6.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),

          if (trailingImage != null)
            Positioned(
              bottom: 30,
              right: 12,
              child: trailingImage!,
            ),
        ],
      ),
    );
  }
}
