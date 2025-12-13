import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomSalescard extends StatelessWidget {
  const CustomSalescard({super.key, required this.date, required this.company, required this.name, required this.price, required this.status});
  final String date;
  final String company;
  final String name;
  final String price;
  final String status;


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(date, style:  TextStyle(color: Colors.grey)),
                 Spacer(),
                Text(company),
              ],
            ),
             Gap(8.h),
            Row(
              children: [
                CircleAvatar(child: Text(name[0])),
                 Gap(10.w),
                Text(name),
                 Spacer(),
                Text(price, style:  TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Gap(10.h),
            Row(
              children: [
                Container(
                 padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xff0909FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style:  TextStyle(color: Colors.white),
                  ),
                ),
                 Spacer(),
                IconButton(
                  icon:  Icon(Icons.edit),
                  onPressed: () {},
                ),
                IconButton(
                  icon:  Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

