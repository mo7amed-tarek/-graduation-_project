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
                  purchase.id,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  '${purchase.date.year}/${purchase.date.month}/${purchase.date.day}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),

            Gap(10.h),

            Text(
              purchase.category,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),

            Gap(10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(purchase.quantity),
                Text(
                  purchase.amount,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Gap(8.h),

            Text(
              purchase.supplierName,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),

            Gap(10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: purchase.status.toLowerCase() == 'completed'
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    purchase.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: edit, icon: const Icon(Icons.edit)),
                    IconButton(
                      onPressed: delete,
                      icon: const Icon(Icons.delete, color: Colors.red),
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
