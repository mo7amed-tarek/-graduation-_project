import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
    final bool isPending = purchase.status.toLowerCase() == 'pending';

    Color statusColor = isPending
        ? const Color(0xffF54900)
        : const Color(0xff00A63E);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.h),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 14.sp,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14.sp, color: Colors.grey),
                    Gap(4.w),
                    Text(
                      purchase.employee,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Gap(12.h),

            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange.shade50,
                  radius: 18.r,
                  child: Text(
                    purchase.supplierName[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        purchase.supplierName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        "${purchase.category} • ${purchase.product}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                Text(
                  purchase.amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            Gap(15.h),

            Row(
              children: [
                _buildStatusChip(statusColor),
                const Spacer(),
                if (isPending)
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue, size: 24.sp),
                    onPressed: edit,
                  ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 22.sp),
                  onPressed: delete,
                ),
              ],
            ),

            if (isPending) ...[
              Gap(10.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updated = purchase.copyWith(status: 'Completed');
                    context.read<PurchasesProvider>().updatePurchaseByModel(
                      purchase,
                      updated,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const Text('Confirm Purchase'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        purchase.status,
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
