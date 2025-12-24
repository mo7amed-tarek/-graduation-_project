import 'package:codecrefactos/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../widgets/appbar.dart';
import '../../../widgets/confirm_delete_sheet.dart';
import '../../sales/widget/Custom_Total_cart.dart';
import '../../sales/widget/custom_SummaryCard.dart';
import '../viewmodels/Purchase_Provider.dart';
import '../witget/Purchase_cart.dart';
import '../witget/add_purchase_sheet.dart';

import '../viewmodels/purchase_model.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

List<String> Categories = [
  'All',
  'Electronics',
  'Furniture',
  'Office Supplies',
  'Devices',
  'Other',
];
int selectContainer = -1;

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PurchasesProvider>();
    final purchases = provider.filteredPurchases;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: Appbar(
        showAddButton: true,
        showLogoutButton: false,
        bottonTitle: 'Add Purchase Order',
        onAdd: () async {
          final purchaseData = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const AddPurchaseSheet(),
          );
          if (purchaseData != null && purchaseData is Purchase) {
            context.read<PurchasesProvider>().addPurchase(purchaseData);
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Purchase Management", style: TextStyle(fontSize: 30.sp)),
              Text(
                "View and manage all purchases",
                style: TextStyle(
                  color: const Color(0xff717182),
                  fontSize: 16.sp,
                ),
              ),
              Gap(9.h),

              CustomTotalCart(
                total: "Total Purchases",
                price: "\$${provider.totalPurchasesAmount.toStringAsFixed(2)}",
                imagePath: 'assets/Purchase.png',
                cardColor: const Color(0xffFFF2E1),
              ),
              Gap(10.h),

              Row(
                children: [
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Completed',
                      value: provider.completedPurchasesCount.toString(),
                      valueColor: const Color(0xff00A63E),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Pending',
                      value: provider.pendingPurchasesCount.toString(),
                      valueColor: const Color(0xffF54900),
                      trailingImage: SizedBox(
                        width: 28.w,
                        height: 28.h,
                        child: Image.asset('assets/Icon (1).png'),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(9.h),

              /// Categories
              SizedBox(
                height: 36.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: Categories.length,
                  separatorBuilder: (_, __) => Gap(10.w),
                  itemBuilder: (context, index) {
                    bool isSelect = index == selectContainer;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectContainer = index;
                        });
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 36.h,
                          maxHeight: 36.h,
                          minWidth: 150.w,
                          maxWidth: 150.w,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: isSelect ? Colors.black : Colors.white54,
                          ),
                          child: Center(
                            child: Text(
                              Categories[index],
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: isSelect ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Gap(10.h),

              /// Search
              TextField(
                onChanged: provider.setPurchaseSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search purchases...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              Gap(15.h),

              /// Purchases List
              purchases.isEmpty
                  ? SizedBox(
                      height: 300.h,
                      child: const AppEmptyState(
                        icon: Icons.shopping_cart_outlined,
                        title: "No Purchases Found",
                        subtitle:
                            "Start adding purchases by tapping the button above.",
                      ),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: purchases.length,
                      itemBuilder: (context, index) {
                        final p = purchases[index];
                        return CustomPurchaseCard(
                          purchase: p,
                          edit: () async {
                            final updatedPurchase = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) =>
                                  AddPurchaseSheet(isEdit: true, purchase: p),
                            );
                            if (updatedPurchase != null &&
                                updatedPurchase is Purchase) {
                              context
                                  .read<PurchasesProvider>()
                                  .updatePurchaseByModel(p, updatedPurchase);
                            }
                          },
                          delete: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ConfirmDeleteSheet(
                                title: 'Delete Purchase',
                                message:
                                    'Are you sure you want to delete this purchase?',
                                onConfirm: () {
                                  context.read<PurchasesProvider>().removePurchase(
                                    p,
                                  );
                                },
                              ),
                            );
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
