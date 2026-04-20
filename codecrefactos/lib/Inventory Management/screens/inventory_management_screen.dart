import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../viewmodels/inventory_viewmodel.dart';
import '../widgets/item_card.dart';
import 'package:codecrefactos/widgets/appbar.dart';
import 'package:codecrefactos/widgets/confirm_delete_sheet.dart';
import 'package:codecrefactos/widgets/empty_state.dart';
import 'package:codecrefactos/Inventory%20Management/widgets/Add_Product_Bottom_Sheet.dart';
import 'package:codecrefactos/views/sales/widget/Custom_Total_cart.dart';
import 'package:codecrefactos/views/sales/widget/custom_SummaryCard.dart';
import 'package:codecrefactos/views/sales/widget/search_filter.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryViewModel>().loadItems();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<InventoryViewModel>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InventoryViewModel>();

    return Scaffold(
      extendBody: true,
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
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(vm.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.loadItems(refresh: true),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.all(12.w),
                children: [
                  Text(
                    "Inventory Management",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Gap(15.h),

                  CustomTotalCart(
                    total: "Total Items",
                    price: vm.totalItems.toString(),
                    imagePath: "assets/total_item.png",
                    cardColor: const Color(0xFFE6FDEE),
                  ),

                  Gap(10.h),

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

                  SearchFilter(
                    showDropdown: false,
                    onChanged: (value) {
                      context.read<InventoryViewModel>().setSearchQuery(value);
                    },
                  ),

                  Gap(15.h),

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
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.items.length + 1,
                          itemBuilder: (context, index) {
                            if (index < vm.items.length) {
                              return InventoryItemCard(
                                item: vm.items[index],
                                onEdit: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) =>
                                        AddProductSheet(item: vm.items[index]),
                                  );
                                },
                                onDelete: () {
                                  _showConfirmDelete(
                                    context,
                                    onConfirm: () =>
                                        vm.deleteItem(vm.items[index]),
                                  );
                                },
                              );
                            } else {
                              return vm.isLoadingMore
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const SizedBox();
                            }
                          },
                        ),
                ],
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
      builder: (_) => ConfirmDeleteSheet(
        title: "Delete Product",
        message: "Are you sure you want to delete this product?",
        onConfirm: onConfirm,
      ),
    );
  }
}
