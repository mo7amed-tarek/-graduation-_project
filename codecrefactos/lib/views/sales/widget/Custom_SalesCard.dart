import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../viewmodels/sale_model.dart';
import '../../../widgets/confirm_delete_sheet.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/sales_provider.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
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
                  ),
                ),
                Text(saleModel.employee),
                Text(saleModel.category),
              ],
            ),

            Gap(8.h),

            Row(
              children: [
                CircleAvatar(child: Text(saleModel.customerName[0])),
                Gap(10.w),
                Text(saleModel.customerName),
                const Spacer(),
                Text(
                  saleModel.amount,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Gap(10.h),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    saleModel.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),

                if (saleModel.status.toLowerCase() == 'pending')
                  IconButton(icon: const Icon(Icons.edit), onPressed: edit),

                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    if (delete != null) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ConfirmDeleteSheet(
                          title: 'Are you sure?',
                          message:
                              'This will delete the sale. This action cannot be undone.',
                          onConfirm: delete!,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            if (saleModel.status.toLowerCase() == 'pending') ...[
              Gap(8.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedSale = saleModel.copyWith(status: 'Completed');
                    context.read<SalesProvider>().updateSaleByModel(
                      saleModel,
                      updatedSale,
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
