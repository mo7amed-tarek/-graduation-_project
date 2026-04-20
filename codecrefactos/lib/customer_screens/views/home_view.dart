import 'package:codecrefactos/customer_screens/views/cart_view.dart';
import 'package:codecrefactos/customer_screens/views/product%20_view.dart';
import 'package:codecrefactos/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import '../widgets/rating_stars.dart';

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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,

        actions: [
          // Cart Button
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartView()),
              );
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
          preferredSize: const Size.fromHeight(48),
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
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.blue,
                  size: 22,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
            ),
          ),

          // Grid
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
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 52,
                          color: Colors.black26,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No products found',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemBuilder: (_, i) {
                    if (i >= filteredProducts.length) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }

                    final product = filteredProducts[i];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductView(product: product),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                              child: Container(
                                height: 130,
                                width: double.infinity,
                                color: Colors.grey.shade100,
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  imageUrl(product.image),
                                  fit: BoxFit.contain,
                                  loadingBuilder: (_, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.black26,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),

                            // Info
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                10,
                                10,
                                10,
                                10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'EGP ${product.price}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  RatingStars(rating: product.rating),
                                ],
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
