import 'package:codecrefactos/Inventory%20Management/widgets/Add_Product_Bottom_Sheet.dart';
import 'package:codecrefactos/views/sales/widget/Custom_Total_cart.dart';
import 'package:codecrefactos/views/sales/widget/custom_SummaryCard.dart';
import 'package:codecrefactos/views/sales/widget/search_filter.dart';
import 'package:codecrefactos/widgets/appbar.dart';
import 'package:codecrefactos/widgets/confirm_delete_sheet.dart';
import 'package:codecrefactos/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../viewmodels/inventory_viewmodel.dart';
import '../widgets/item_card.dart';

class InventoryManagementScreen extends StatelessWidget {
  const InventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InventoryViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: Appbar(
        showLogoutButton: false,
        bottonTitle: 'Add',
        onAdd: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddProductSheet(),
          );
        },
        onLogout: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان الرئيسي
              Text(
                "Inventory Management",
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
              ),
              Gap(3.h),
              Text(
                "View and manage warehouse products",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
              Gap(15.h),

              // Total Cart
              CustomTotalCart(
                total: "Total Items",
                price: vm.totalItems.toString(),
                imagePath: "assets/total_item.png",
                cardColor: const Color(0xFFE6FDEE),
              ),
              Gap(8.h),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: CustomSummaryCard(
                      title: "Low Stock Items",
                      value: vm.lowStockCount.toString(),
                      valueColor: Colors.red,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: CustomSummaryCard(
                      title: "Categories",
                      value: vm.categoriesCount.toString(),
                      valueColor: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              Gap(16.h),

              // Low stock warning
              if (vm.lowStockCount > 0)
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          "${vm.lowStockCount} items are running low on stock. Please reorder soon.",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Gap(10.h),

              // Search Filter
              const SearchFilter(showDropdown: false),
              Gap(15.h),

              // Items List
              vm.items.isEmpty
                  ? SizedBox(
                      height: 300.h,
                      child: const AppEmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: "No Products Found",
                        subtitle:
                            "Start adding products by tapping the button above.",
                      ),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vm.items.length,
                      itemBuilder: (context, index) => InventoryItemCard(
                        item: vm.items[index],
                        onEdit: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => AddProductSheet(
                              item: vm.items[index],
                              index: index,
                            ),
                          );
                        },
                        onDelete: () {
                          _showConfirmDelete(
                            context,
                            onConfirm: () {
                              vm.deleteItem(index);
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

  void _showConfirmDelete(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => ConfirmDeleteSheet(
        title: "Delete Product",
        message: "Are you sure you want to delete this product?",
        onConfirm: onConfirm,
      ),
    );
  }
}
