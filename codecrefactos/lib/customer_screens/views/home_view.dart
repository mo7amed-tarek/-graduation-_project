import 'package:codecrefactos/customer_screens/views/cart_view.dart';
import 'package:codecrefactos/customer_screens/views/product%20_view.dart';
import 'package:codecrefactos/login_screen/login_screen.dart';
import 'package:codecrefactos/widgets/chat_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import '../view_models/cart_view_model.dart';
import '../widgets/rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ['Mobiles', 'Laptops', 'Accessories'];
  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);

    Future.microtask(() {
      context.read<HomeVM>().fetchProducts(refresh: true);
    });

    _scrollController.addListener(() {
      final vm = context.read<HomeVM>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!vm.isLoadingMore && vm.hasMore) {
          vm.fetchProducts();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String imageUrl(String path) {
    if (path.startsWith('http')) return path;
    const baseUrl = "http://store2.runasp.net";
    return "$baseUrl${path.startsWith('/') ? '' : '/'}$path";
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase().trim()) {
      case 'mobiles':
        return const Color(0xFF1565C0);
      case 'laptops':
        return const Color(0xFF2E7D32);
      case 'accessories':
        return const Color(0xFF6A1B9A);
      default:
        return Colors.blueGrey;
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
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
    final vm = context.watch<HomeVM>();

    if (vm.isLoading && vm.products.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return Scaffold(
      floatingActionButton: ChatFloatingButton(),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartView()),
              ).then((_) {
                context.read<HomeVM>().fetchProducts(refresh: true);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<HomeVM>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black45,
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 14.sp),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.blue,
                  size: 22.sp,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 14.r),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: Colors.blue, width: 1.5.w),
                ),
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                final filteredProducts = vm.products.where((product) {
                  final matchesCategory =
                      product.categoryName.toLowerCase().trim() ==
                      category.toLowerCase().trim();
                  final matchesSearch = product.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                  return matchesCategory && matchesSearch;
                }).toList();

                if (filteredProducts.isEmpty && !vm.isLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 52.sp,
                          color: Colors.black26,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'No products found',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  itemCount:
                      filteredProducts.length + (vm.isLoadingMore ? 1 : 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68.h,
                    mainAxisSpacing: 14.w,
                    crossAxisSpacing: 14.w,
                  ),
                  itemBuilder: (_, i) {
                    if (i >= filteredProducts.length) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }

                    final product = filteredProducts[i];
                    final badgeColor = _categoryColor(product.categoryName);

                    return GestureDetector(
                      onTap: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductView(product: product),
                            ),
                          ).then((_) {
                            context.read<HomeVM>().fetchProducts(refresh: true);
                          }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 10.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(18.r),
                                  ),
                                  child: Container(
                                    height: 130.h,
                                    width: double.infinity,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10.r),
                                    child: Image.network(
                                      imageUrl(product.image),
                                      fit: BoxFit.contain,
                                      loadingBuilder: (_, child, progress) {
                                        if (progress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                            strokeWidth: 2.w,
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.black26,
                                        size: 36.sp,
                                      ),
                                    ),
                                  ),
                                ),

                                if (product.isOutOfStock)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(18.r),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Out of Stock',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                  ),

                                if (product.isLowStock)
                                  Positioned(
                                    top: 8.h,
                                    left: 8.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade700,
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Only ${product.quantity} left!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(18.r),
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(
                                  10.w,
                                  8.h,
                                  10.w,
                                  8.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: badgeColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        product.categoryName,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: badgeColor,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 5.h),

                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        color: Colors.black87,
                                        height: 1.3,
                                      ),
                                    ),

                                    SizedBox(height: 4.h),

                                    Text(
                                      'EGP ${product.price}',
                                      style: TextStyle(
                                        color: const Color(0xFF185FA5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.sp,
                                      ),
                                    ),

                                    SizedBox(height: 4.h),

                                    RatingStars(rating: product.rating),

                                    const Spacer(),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (product.colors.isNotEmpty)
                                          Row(
                                            children: product.colors
                                                .take(4)
                                                .map(
                                                  (colorInt) => Container(
                                                    width: 13.w,
                                                    height: 13.w,
                                                    margin: EdgeInsets.only(
                                                      right: 4.w,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(colorInt),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.black12,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),

                                        GestureDetector(
                                          onTap: product.isOutOfStock
                                              ? () => _showSnackbar(
                                                  'Sorry, this product is out of stock',
                                                  isError: true,
                                                )
                                              : () async {
                                                  final error = await context
                                                      .read<CartVM>()
                                                      .addItem(product);
                                                  if (error != null) {
                                                    _showSnackbar(
                                                      error,
                                                      isError: true,
                                                    );
                                                  } else {
                                                    _showSnackbar(
                                                      'Added to cart ✓',
                                                    );

                                                    context
                                                        .read<HomeVM>()
                                                        .fetchProducts(
                                                          refresh: true,
                                                        );
                                                  }
                                                },
                                          child: Container(
                                            width: 30.w,
                                            height: 30.w,
                                            decoration: BoxDecoration(
                                              color: product.isOutOfStock
                                                  ? Colors.grey.shade400
                                                  : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Colors.white,
                                              size: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
