import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../viewmodels/sale_model.dart';
import '../../../widgets/confirm_delete_sheet.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sales_provider.dart';

class CustomSalescard extends StatelessWidget {
  const CustomSalescard({
    super.key,
    required this.saleModel,
    this.delete,
    this.edit,
  });

  final SaleModel saleModel;
  final VoidCallback? delete;
  final VoidCallback? edit;

  @override
  Widget build(BuildContext context) {
    Color statusColor = saleModel.status.toLowerCase() == 'completed'
        ? const Color(0xff00A63E)
        : const Color(0xffF54900);

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
                  saleModel.invoiceNumber,
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
                      saleModel.employee,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),

            Gap(12.h),

            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  radius: 18.r,
                  child: Text(
                    saleModel.customerName[0].toUpperCase(),
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        saleModel.customerName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                      Text(
                        "${saleModel.category} • ${saleModel.product}",
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$${saleModel.amount}",
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

                if (saleModel.status.toLowerCase() == 'pending')
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue, size: 24.sp),
                    onPressed: edit,
                  ),

                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 22.sp),
                  onPressed: () => _showDeleteDialog(context),
                ),
              ],
            ),

            if (saleModel.status.toLowerCase() == 'pending') ...[
              Gap(10.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedSale = saleModel.copyWith(status: 'Completed');
                    context.read<SalesProvider>().updateSaleByModel(saleModel, updatedSale);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: const Text('Confirm Sale'),
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
        // color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        saleModel.status,
        style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ConfirmDeleteSheet(
        title: 'Delete Sale?',
        message: 'Are you sure you want to remove this record?',
        onConfirm: delete!,
      ),
    );
  }
}