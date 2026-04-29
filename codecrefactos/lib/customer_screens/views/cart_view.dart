import 'package:codecrefactos/customer_screens/views/product%20_view.dart';
import 'package:codecrefactos/widgets/chat_boot.dart';
import 'package:codecrefactos/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/cart_view_model.dart';
import '../view_models/home_view_model.dart';
import 'confirm_view.dart';
import 'home_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  String fixImageUrl(String url) {
    const baseUrl = "http://store2.runasp.net";
    if (url.isEmpty) return "";
    if (url.startsWith("http")) return url;
    return baseUrl + url;
  }

  void _showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartVM>();
    final homeVM = context.watch<HomeVM>();

    return Scaffold(
      floatingActionButton: ChatFloatingButton(),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Order',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),

            cartVM.items.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : Column(
                    children: cartVM.items.map((item) {
                      // جيب الـ stock quantity من الـ HomeVM
                      final matchedProduct = homeVM.products
                          .where((p) => int.tryParse(p.id) == item.productId)
                          .firstOrNull;
                      final int stockQty = matchedProduct?.quantity ?? 0;
                      final bool isAtMax = item.quantity >= stockQty;

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6.r),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              fixImageUrl(item.pictureUrl),
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${item.price} EGP',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Low stock warning داخل الكارت
                                  if (isAtMax && stockQty > 0)
                                    Text(
                                      'Max quantity reached ($stockQty in stock)',
                                      style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () =>
                                          cartVM.decreaseQuantity(item),
                                    ),
                                    Text(item.quantity.toString()),
                                    // ── زرار + مع validation ──────────────
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: isAtMax
                                            ? Colors.grey.shade400
                                            : Colors.black,
                                      ),
                                      onPressed: isAtMax
                                          ? () => _showSnackbar(
                                              context,
                                              'Only $stockQty item(s) available in stock',
                                              isError: true,
                                            )
                                          : () async {
                                              final error = await cartVM
                                                  .increaseQuantity(
                                                    item,
                                                    stockQuantity: stockQty,
                                                  );
                                              if (error != null) {
                                                _showSnackbar(
                                                  context,
                                                  error,
                                                  isError: true,
                                                );
                                              }
                                            },
                                    ),
                                    // ──────────────────────────────────────
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => cartVM.removeItem(item),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

            SizedBox(height: 24.h),

            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${cartVM.total.toStringAsFixed(0)} EGP',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: cartVM.items.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConfirmOrderView(),
                          ),
                        );
                      },
                child: Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Buy Again',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeView()),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            SizedBox(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeVM.products.length,
                itemBuilder: (context, index) {
                  final product = homeVM.products[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductView(product: product),
                        ),
                      );
                    },
                    child: Container(
                      width: 140.w,
                      margin: EdgeInsets.only(right: 12.r),
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6.r),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Image.network(
                                  fixImageUrl(product.image),
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                                if (product.isOutOfStock)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black45,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Out of\nStock',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${product.price} EGP',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.isLowStock)
                            Text(
                              'Only ${product.quantity} left!',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerServiceChatView(),
                    ),
                  );
                },
                child: const Text(
                  'Customer Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
