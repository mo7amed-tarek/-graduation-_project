import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomTotalCart extends StatelessWidget {
  const CustomTotalCart({
    super.key,
    required this.total,
    required this.price,
    required this.imagePath,
  });

  final String total;
  final String price;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(total,
                    style: TextStyle(
                        color: Color(0xff1447E6),
                        fontSize: 20.sp
                    )),
                Gap(6.h),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Color(0xff1C398E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(width: 32.w, height: 32.h, child: Image.asset(imagePath)),
          ],
        ),
      ),
    );
  }
}
