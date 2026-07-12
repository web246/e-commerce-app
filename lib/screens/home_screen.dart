import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/common/product_card.dart';
import '../widgets/common/section_header.dart';
import '../widgets/layout/bottom_nav.dart';
import '../widgets/layout/top_bar.dart';
import '../providers/products_provider.dart';
import '../providers/categories_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pp = context.read<ProductsProvider>();
      pp.fetchFeatured();
      pp.fetchFlashSale();
      pp.fetchTrending();
      pp.fetchBestSellers();
      context.read<CategoriesProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 76;
    final gridCount = width < 60? 2 : width < 90 ? 1 : 2;
    final gridAspect = width < 60 ? 0.72 : width < 90 ? 0.45 : 0.22;
    final productsProvider = context.watch<ProductsProvider>();

    return Scaffold(
      body: Column(
        children: [
          TopBar(
            onSearchTap: () => context.go('/search'),
            onWishlistTap: () => context.go('/wishlist'),
            onCartTap: () => context.go('/cart'),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final pp = context.read<ProductsProvider>();
                await Future.wait([
                  pp.fetchFeatured(),
                  pp.fetchFlashSale(),
                  pp.fetchTrending(),
                  pp.fetchBestSellers(),
                ]);
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Hero Banner
                        _HeroBanner(),
                        const SizedBox(height: 24),
                        // Category Strip
                        _CategoryStrip(),
                        const SizedBox(height: 24),
                        // Flash Sale Section
                        SectionHeader(
                          title: 'Flash Sale',
                          badge: '🔥 6h left',
                          onViewAll: () => context.go('/search'),
                        ),
                        const SizedBox(height: 12),
                        _FlashSaleCountdown(),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 280,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productsProvider.flashSale.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 160,
                                child: ProductCard(
                                  product: productsProvider.flashSale[index],
                                  onTap: () => context.go('/product/${productsProvider.flashSale[index].slug}'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                  // Trending Now
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Trending Now',
                      onViewAll: () => context.go('/search'),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: gridAspect,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(
                          product: productsProvider.trending[index % productsProvider.trending.length],
                          onTap: () => context.go('/product/${productsProvider.trending[index % productsProvider.trending.length].slug}'),
                        ),
                        childCount: 8,
                      ),
                    ),
                  ),
                  // Best Sellers
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Best Sellers',
                      onViewAll: () => context.go('/search'),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: gridAspect,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(
                          product: productsProvider.bestSellers[index % productsProvider.bestSellers.length],
                          onTap: () => context.go('/product/${productsProvider.bestSellers[index % productsProvider.bestSellers.length].slug}'),
                        ),
                        childCount: 8,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNav(
              currentTab: BottomNavTab.values[_currentBottomTab],
              onTabChanged: (tab) {
                setState(() => _currentBottomTab = BottomNavTab.values.indexOf(tab));
                switch (tab) {
                  case BottomNavTab.home:
                    context.go('/');
                    break;
                  case BottomNavTab.categories:
                    context.go('/categories');
                    break;
                  case BottomNavTab.cart:
                    context.go('/cart');
                    break;
                  case BottomNavTab.orders:
                    context.go('/orders');
                    break;
                  case BottomNavTab.profile:
                    context.go('/profile');
                    break;
                }
              },
            )
          : null,
    );
  }
}

class _HeroBanner extends StatefulWidget {
  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> {
  int _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    final banners = [
      'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800',
      'https://images.unsplash.com/photo-1552883564-e0e7b5f28c3d?w=800',
    ];

    return SizedBox(
      height: 20,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) => setState(() => _currentBanner = index),
            itemCount: banners.length,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                banners[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.secondary,
                  child: const Center(child: Icon(Icons.image)),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: i == _currentBanner ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = context.watch<CategoriesProvider>();
    final categories = categoriesProvider.categories;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final name = category.name;
          final icon = category.icon ?? '📦';
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => context.go('/categories/$name'),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.categoryColors[name]?.withOpacity(0.15) ?? AppTheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(name, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FlashSaleCountdown extends StatefulWidget {
  @override
  State<_FlashSaleCountdown> createState() => _FlashSaleCountdownState();
}

class _FlashSaleCountdownState extends State<_FlashSaleCountdown> {
  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProductsProvider>();
    if (pp.flashSale.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('No active flash sales'),
      );
    }
    final endTime = pp.flashSale.first.flashSaleEnd;
    if (endTime == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('No active flash sales'),
      );
    }
    final remaining = endTime.difference(DateTime.now());
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _CountdownBox(label: 'Hours', value: hours),
          const SizedBox(width: 8),
          _CountdownBox(label: 'Minutes', value: minutes),
          const SizedBox(width: 8),
          _CountdownBox(label: 'Seconds', value: seconds),
        ],
      ),
    );
  }
}

class _CountdownBox extends StatelessWidget {
  final String label;
  final String value;

  const _CountdownBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground),
          ),
        ],
      ),
    );
  }
}

