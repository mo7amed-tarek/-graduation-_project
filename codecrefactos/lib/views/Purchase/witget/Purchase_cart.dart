import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../viewmodels/purchase_model.dart';

class PurchaseCart extends StatelessWidget {
  const PurchaseCart({
    super.key,
    required this.purchase,
    required this.edit,
    required this.delete,
  });

  final Purchase purchase;
  final VoidCallback edit;
  final VoidCallback delete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.98),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${purchase.date.year}/${purchase.date.month}/${purchase.date.day}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                Text(
                  purchase.category,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Gap(12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  purchase.quantity,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  purchase.amount,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Gap(12.h),

            Text(
              purchase.supplierName,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),

            Gap(10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Text(
                      purchase.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: edit,
                      icon: Icon(Icons.edit),
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: delete,
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
