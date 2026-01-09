import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:codecrefactos/Inventory%20Management/viewmodels/inventory_viewmodel.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const InventoryItemCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  double _safePercent(double value) {
    if (value.isNaN || value.isInfinite) return 0.0;
    return value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final percent = _safePercent(item.stockRatio);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.category,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),

            Gap(4.h),

            Text(
              item.date,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),

            Gap(6.h),
            Text("Unit Price: \$${item.unitPrice}"),
            Gap(6.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(percent * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Gap(6.h),

            LinearPercentIndicator(
              lineHeight: 6.h,
              percent: percent,
              backgroundColor: Colors.grey.shade300,
              progressColor: item.isLowStock ? Colors.red : Colors.blue,
              barRadius: Radius.circular(10.r),
              padding: EdgeInsets.zero,
            ),

            Gap(10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: item.isLowStock
                        ? Colors.red.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    item.isLowStock ? "Low Stock" : "Normal",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: item.isLowStock ? Colors.red : Colors.blue,
                    ),
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit,
                        size: 20.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, size: 20.sp, color: Colors.red),
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
