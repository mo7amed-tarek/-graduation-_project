import 'package:codecrefactos/customer_screens/view_models/product_view_model.dart';
import 'package:codecrefactos/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../view_models/cart_view_model.dart';
import '../view_models/home_view_model.dart';
import '../widgets/rating_stars.dart';
import '../widgets/color_selector.dart';
import '../widgets/action_buttons.dart';
import 'cart_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductView extends StatelessWidget {
  final Product product;
  const ProductView({super.key, required this.product});

  String fixImageUrl(String url) {
    const baseUrl = "http://store2.runasp.net";
    if (url.isEmpty) return "";
    if (url.startsWith("http")) return url;
    return "$baseUrl${url.startsWith('/') ? '' : '/'}$url";
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

  Future<void> _handleAddToCart(BuildContext context) async {
    if (product.isOutOfStock) {
      _showSnackbar(
        context,
        'Sorry, this product is out of stock',
        isError: true,
      );
      return;
    }

    final error = await context.read<CartVM>().addItem(product);
    if (error != null) {
      _showSnackbar(context, error, isError: true);
    } else {
      _showSnackbar(context, 'Added to cart ✓');
    }
  }

  Future<void> _handleBuyNow(BuildContext context) async {
    if (product.isOutOfStock) {
      _showSnackbar(
        context,
        'Sorry, this product is out of stock',
        isError: true,
      );
      return;
    }

    final error = await context.read<CartVM>().addItem(product);
    if (error != null) {
      _showSnackbar(context, error, isError: true);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = context.read<HomeVM>();

    return ChangeNotifierProvider(
      create: (_) => ProductVM(product),
      child: Scaffold(
        floatingActionButton: ChatFloatingButton(),
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text('Product Detail'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Consumer<ProductVM>(
          builder: (_, vm, __) {
            final similarProducts = homeVM.products
                .where(
                  (p) =>
                      p.categoryName == product.categoryName &&
                      p.id != product.id,
                )
                .toList();

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Product Image ───────────────────────────────────────
                  Hero(
                    tag: product.id,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Image.network(
                            fixImageUrl(product.image),
                            height: 180.h,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return SizedBox(
                                height: 180.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint("Image Error: ${product.image}");
                              return SizedBox(
                                height: 180.h,
                                child: Icon(Icons.broken_image, size: 50.sp),
                              );
                            },
                          ),
                        ),

                        // Out of Stock overlay on image
                        if (product.isOutOfStock)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Out of Stock',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),

                        // Low Stock badge
                        if (product.isLowStock)
                          Positioned(
                            top: 12.h,
                            left: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade700,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Only ${product.quantity} left!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ───────────────────────────────────────────────────────
                  SizedBox(height: 12.h),

                  RatingStars(rating: product.rating),

                  SizedBox(height: 8.h),

                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    '${product.price} EGP',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(product.description),

                  SizedBox(height: 16.h),

                  const Text(
                    'Color',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8.h),

                  ColorSelector(
                    colors: product.colors,
                    selected: vm.selectedColor,
                    onSelect: vm.selectColor,
                  ),

                  SizedBox(height: 24.h),

                  // ── Action Buttons ──────────────────────────────────────
                  ActionButtons(
                    add: () => _handleAddToCart(context),
                    buy: () => _handleBuyNow(context),
                  ),

                  // ───────────────────────────────────────────────────────
                  SizedBox(height: 32.h),

                  if (similarProducts.isNotEmpty) ...[
                    Text(
                      'Similar Products',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    SizedBox(
                      height: 180.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarProducts.length,
                        itemBuilder: (context, index) {
                          final simProd = similarProducts[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductView(product: simProd),
                                ),
                              );
                            },
                            child: Container(
                              width: 140.w,
                              margin: EdgeInsets.only(right: 12.w),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.r,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          fixImageUrl(simProd.image),
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                  ),
                                        ),
                                        // Out of stock overlay on similar product
                                        if (simProd.isOutOfStock)
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
                                    simProd.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${simProd.price} EGP',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Low stock label on similar product
                                  if (simProd.isLowStock)
                                    Text(
                                      'Only ${simProd.quantity} left!',
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
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
