import 'package:codecrefactos/customer_screens/view_models/product_view_model.dart';
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

    if (url.startsWith("http")) {
      return url;
    }

    return "$baseUrl${url.startsWith('/') ? '' : '/'}$url";
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = context.read<HomeVM>();

    return ChangeNotifierProvider(
      create: (_) => ProductVM(product),
      child: Scaffold(
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
                  Hero(
                    tag: product.id,
                    child: Container(
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
                            child: Center(child: CircularProgressIndicator()),
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
                  ),

                  SizedBox(height: 12.h),

                  /// Rating
                  RatingStars(rating: product.rating),

                  SizedBox(height: 8.h),

                  /// Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// Price
                  Text(
                    '${product.price} EGP',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// Description
                  Text(product.description),

                  SizedBox(height: 16.h),

                  /// Colors
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

                  /// Buttons
                  ActionButtons(
                    add: () {
                      context.read<CartVM>().addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    buy: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartView()),
                      );
                    },
                  ),

                  SizedBox(height: 32.h),

                  /// Similar Products
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
                                    child: Image.network(
                                      fixImageUrl(simProd.image),
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
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
