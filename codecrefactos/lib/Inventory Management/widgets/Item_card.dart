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

  double _safePercent(int quantity) {
    if (quantity <= 0) return 0.0;
    return (quantity / 100).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final percent = _safePercent(item.quantity);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Category ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Cat #${item.categoryId}",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            Gap(6.h),

            // Description
            if (item.description.isNotEmpty)
              Text(
                item.description,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            Gap(6.h),

            // Color + Price
            Row(
              children: [
                if (item.color.isNotEmpty) ...[
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: _parseColor(item.color),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  Gap(6.w),
                  Text(
                    item.color,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Gap(12.w),
                ],
                const Spacer(),
                Text(
                  "Price: \$${item.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            Gap(10.h),

            // Stock label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stock",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                Text(
                  "${item.quantity} units",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: item.isLowStock ? Colors.red : Colors.black87,
                  ),
                ),
              ],
            ),

            Gap(6.h),

            // Progress bar
            LinearPercentIndicator(
              lineHeight: 6.h,
              percent: percent,
              backgroundColor: Colors.grey.shade300,
              progressColor: item.isLowStock ? Colors.red : Colors.blue,
              barRadius: Radius.circular(10.r),
              padding: EdgeInsets.zero,
            ),

            Gap(10.h),

            // Status + Actions
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
                    item.isLowStock ? "Low Stock" : "In Stock",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: item.isLowStock ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.w500,
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

  Color _parseColor(String colorName) {
    switch (colorName.toLowerCase().trim()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.grey.shade400;
    }
  }
}
