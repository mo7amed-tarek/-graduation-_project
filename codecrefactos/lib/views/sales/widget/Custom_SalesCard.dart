import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../viewmodels/sale_model.dart';
import '../../../widgets/confirm_delete_sheet.dart';
import 'add_sales_sheet.dart';

class CustomSalescard extends StatelessWidget {
   CustomSalescard({super.key, required this.saleModel, this.delete, this.edit});

  final SaleModel saleModel;
  void Function() ? delete;
   void Function() ? edit;


   @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('22/10/2025', style: TextStyle(color: Colors.grey)),
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
                Spacer(),
                Text(
                  '${saleModel.amount}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                    'completed',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.edit), onPressed:edit

                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => ConfirmDeleteSheet(
                        title: 'Are you sure?',
                        message:
                            'This will delete the sale. This action cannot be undone.',
                        onConfirm: delete!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
