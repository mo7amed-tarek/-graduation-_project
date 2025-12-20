import 'package:codecrefactos/widgets/empty_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../widgets/appbar.dart';
import '../../../widgets/confirm_delete_sheet.dart';
import '../../sales/widget/Custom_Total_cart.dart';
import '../../sales/widget/custom_SummaryCard.dart';
import '../witget/Purchase_cart.dart';
import '../witget/add_purchase_sheet.dart';

import '../../../viewmodels/sales_provider.dart';
import '../../../viewmodels/purchase_model.dart';
import 'package:provider/provider.dart';

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
    final purchases = context.watch<SalesProvider>().filteredPurchases;

    return Scaffold(
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
            builder: (_) => AddPurchaseSheet(),
          );
          if (purchaseData != null && purchaseData is Purchase) {
            context.read<SalesProvider>().addPurchase(purchaseData);
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Purchase Management",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400),
              ),
              Text(
                "View and manage all purchases",
                style: TextStyle(
                  color: Color(0xff717182),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(9.h),
              CustomTotalCart(
                total: "Total Purchases",
                price: "\$75,500",
                imagePath: 'assets/Purchase.png',
                cardColor: Color(0xffFFF2E1),
              ),
              Gap(10.h),
              Row(
                children: [
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Received Orders',
                      value: '3',
                      valueColor: Color(0xff00A63E),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: CustomSummaryCard(
                      title: 'Pending Orders',
                      value: '1',
                      valueColor: Color(0xffF54900),
                      trailingImage: Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset('assets/Icon (1).png'),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(9.h),
              SizedBox(
                height: 30.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: Categories.length,
                  separatorBuilder: (context, index) => Gap(10.w),
                  itemBuilder: (context, index) {
                    bool isSelect = index == selectContainer;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectContainer = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 36.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.r),
                          color: isSelect ? Colors.black : Colors.white54,
                        ),
                        child: Center(
                          child: Text(
                            Categories[index],
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: isSelect ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Gap(10.h),
              TextField(
                onChanged: (value) {
                  context.read<SalesProvider>().setPurchaseSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search purchases...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              Gap(15.h),
              Expanded(
                child: purchases.isEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            height: constraints.maxHeight,
                            width: double.infinity,
                            child: const AppEmptyState(
                              icon: Icons.shopping_cart_outlined,
                              title: "No Purchases Found",
                              subtitle:
                                  "Start adding purchases by tapping the button above.",
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: purchases.length,
                        itemBuilder: (context, index) {
                          final p = purchases[index];
                          return PurchaseCart(
                            purchase: p,
                            edit: () async {
                              final updatedPurchase =
                                  await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (_) => AddPurchaseSheet(
                                      isEdit: true,
                                      purchase: p,
                                    ),
                                  );
                              if (updatedPurchase != null &&
                                  updatedPurchase is Purchase) {
                                context.read<SalesProvider>().updatePurchaseByModel(
                                      p,
                                      updatedPurchase,
                                    );
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
                                    context.read<SalesProvider>().removePurchase(p);
                                  },
                                ),
                              );
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
