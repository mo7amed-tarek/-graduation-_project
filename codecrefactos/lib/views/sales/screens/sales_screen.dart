import 'package:codecrefactos/viewmodels/sale_model.dart';
import 'package:codecrefactos/views/sales/widget/Custom_SalesCard.dart';
import 'package:codecrefactos/views/sales/widget/search_filter.dart';
import 'package:codecrefactos/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../widgets/appbar.dart';
import '../../../viewmodels/sales_provider.dart';
import '../widget/Custom_Total_cart.dart';
import '../widget/add_sales_sheet.dart';
import '../widget/custom_SummaryCard.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final sales = salesProvider.filteredSales;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: Appbar(
        showLogoutButton: false,
        bottonTitle: 'Add Sales',
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
            context.read<SalesProvider>().addSale(salesData);
          }
        },
        onLogout: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sales Management", style: TextStyle(fontSize: 30.sp)),
              Text(
                "View and manage all sales",
                style: TextStyle(
                  color: const Color(0xff717182),
                  fontSize: 16.sp,
                ),
              ),
              Gap(10.h),

              CustomTotalCart(
                total: "Total Sales",
                price: "\$${salesProvider.totalSalesAmount.toStringAsFixed(2)}",
                imagePath: 'assets/mark.png',
                cardColor: Colors.white,
              ),
              Gap(16.h),

              Row(
                children: [
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Completed Sales',
                      value: salesProvider.completedSalesCount.toString(),
                      valueColor: const Color(0xff00A63E),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Pending Sales',
                      value: salesProvider.pendingSalesCount.toString(),
                      valueColor: const Color(0xffF54900),
                    ),
                  ),
                ],
              ),

              Gap(16.h),

              const SearchFilter(),
              Gap(16.h),

              sales.isEmpty
                  ? SizedBox(
                      height: 300.h,
                      child: const AppEmptyState(
                        icon: Icons.sell_outlined,
                        title: "No Sales Found",
                        subtitle:
                            "Start adding sales by tapping the button above.",
                      ),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sales.length,
                      itemBuilder: (context, index) {
                        final sale = sales[index];
                        return CustomSalescard(
                          saleModel: sale,
                          delete: () {
                            context.read<SalesProvider>().removeSale(sale);
                          },
                          edit: () async {
                            final updatedSaleData = await showModalBottomSheet(
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
                              context.read<SalesProvider>().updateSaleByModel(
                                sale,
                                updatedSaleData,
                              );
                            }
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
