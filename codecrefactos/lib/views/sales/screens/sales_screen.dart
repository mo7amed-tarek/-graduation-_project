import 'package:codecrefactos/viewmodels/sale_model.dart';
import 'package:codecrefactos/views/sales/widget/Custom_SalesCard.dart';
import 'package:codecrefactos/views/sales/widget/search_filter.dart';
import 'package:codecrefactos/widgets/empty_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../widgets/appbar.dart';
import '../widget/Custom_Total_cart.dart';
import '../widget/add_sales_sheet.dart';
import '../widget/custom_SummaryCard.dart';

import '../../../viewmodels/sales_provider.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    // obtain the current sales list from provider
    final sales = context.watch<SalesProvider>().sales;

    return Scaffold(
      appBar: Appbar(
        showLogoutButton: false,
        onAdd: () async {
          final salesData = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => AddSalesSheet(),
          );
          if (salesData != null && salesData is SaleModel) {
            // add via provider
            context.read<SalesProvider>().addSale(salesData);
          }
        },
        onLogout: () {
          // Handle logout action
        },
        bottonTitle: 'Add Sales',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sales Management",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400),
              ),
              Text(
                "View and manage all sales",
                style: TextStyle(
                  color: Color(0xff717182),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(10.h),
              CustomTotalCart(
                total: "Total Sales",
                price: "\$48,900",
                imagePath: 'assets/mark.png',
                cardColor: Colors.white,
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Completed Sales',
                      value: '4',
                      valueColor: Color(0xff00A63E),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Pending Sales',
                      value: '1',
                      valueColor: Color(0xffF54900),
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              SearchFilter(),
              Gap(16.h),
              Expanded(
                child: sales.isEmpty
                    ? const AppEmptyState(
                        icon: Icons.sell_outlined,
                        title: "No Sales Found",
                        subtitle:
                            "Start adding sales by tapping the button above.",
                      )
                    : ListView.builder(
                        itemCount: sales.length,
                        itemBuilder: (context, index) {
                          final sale = sales[index];
                          return CustomSalescard(
                            saleModel: sale,
                            delete: () {
                              // remove via provider
                              context.read<SalesProvider>().removeSaleAt(index);
                            },
                            edit: () async {
                              final updatedSaleData =
                                  await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (_) =>
                                        AddSalesSheet(isEdit: true, sale: sale),
                                  );
                              if (updatedSaleData != null &&
                                  updatedSaleData is SaleModel) {
                                context.read<SalesProvider>().updateSale(
                                  index,
                                  updatedSaleData,
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
