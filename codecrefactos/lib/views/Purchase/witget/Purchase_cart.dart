import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/purchase_model.dart';
import '../../../viewmodels/sales_provider.dart';

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
    bool isPending = purchase.status.toLowerCase() == 'pending';

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
            SizedBox(height: 10.h),
            Text(
              purchase.category,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
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
            SizedBox(height: 8.h),
            Text(
              purchase.supplierName,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPending ? Colors.orange : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    purchase.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    if (isPending)
                      IconButton(onPressed: edit, icon: const Icon(Icons.edit)),
                    IconButton(
                      onPressed: delete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            if (isPending) ...[
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedPurchase = purchase.copyWith(
                      status: 'Completed',
                    );
                    context.read<SalesProvider>().updatePurchaseByModel(
                      purchase,
                      updatedPurchase,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
