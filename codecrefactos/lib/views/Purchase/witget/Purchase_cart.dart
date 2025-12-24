import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/Purchase_Provider.dart';
import '../viewmodels/purchase_model.dart';

class CustomPurchaseCard extends StatelessWidget {
  const CustomPurchaseCard({
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
    final isPending = purchase.status.toLowerCase() == 'pending';
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  purchase.invoiceNumber,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  '${purchase.category} • ${purchase.product}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              purchase.supplierName,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  purchase.employee,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                Text(
                  purchase.amount,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isPending ? const Color(0xffF54900) : const Color(0xff00A63E),
                    borderRadius: BorderRadius.circular(20.r),
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
                    final updated = purchase.copyWith(status: 'Completed');
                    context.read<PurchasesProvider>().updatePurchaseByModel(purchase, updated);
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
