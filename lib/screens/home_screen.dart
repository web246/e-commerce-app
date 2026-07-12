import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/common/product_card.dart';
import '../widgets/common/section_header.dart';
import '../widgets/layout/bottom_nav.dart';
import '../widgets/layout/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomTab = 0;

  final List<Product> _sampleProducts = [
    Product(
      name: 'iPhone 15 Pro',
      slug: 'iphone-15-pro',
      description: 'Latest iPhone with A17 Pro chip',
      storeId: 'store-1',
      storeName: 'Apple Store',
      category: 'Phones',
      subcategory: 'Smartphones',
      brand: 'Apple',
      price: 120000,
      oldPrice: 150000,
      currency: 'KES',
      images: [],
      thumbnail: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500',
      sku: 'IPHONE-15-PRO',
      rating: 4.8,
      reviewsCount: 1250,
      soldCount: 3500,
      status: ProductStatus.active,
      isFeatured: true,
      isFlashSale: true,
      flashSaleEnd: DateTime.now().add(const Duration(hours: 6)),
      freeShipping: true,
      isNewArrival: false,
      isBestSeller: true,
    ),
    Product(
      name: 'Sony WH-1000XM5 Headphones',
      slug: 'sony-wh1000xm5',
      description: 'Premium noise-cancelling headphones',
      storeId: 'store-2',
      storeName: 'Electronics Hub',
      category: 'Electronics',
      subcategory: 'Audio',
      brand: 'Sony',
      price: 45000,
      oldPrice: 55000,
      currency: 'KES',
      images: [],
      thumbnail: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      sku: 'SONY-WH-1000XM5',
      rating: 4.7,
      reviewsCount: 890,
      soldCount: 2100,
      status: ProductStatus.active,
      isFeatured: true,
      isNewArrival: true,
      freeShipping: true,
    ),
    Product(
      name: 'Nike Air Max 90',
      slug: 'nike-air-max-90',
      description: 'Classic sneakers with excellent comfort',
      storeId: 'store-3',
      storeName: 'Fashion Store',
      category: 'Shoes',
      subcategory: 'Sneakers',
      brand: 'Nike',
      price: 12000,
      oldPrice: 15000,
      currency: 'KES',
      images: [],
      thumbnail: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      sku: 'NIKE-AIR-MAX-90',
      rating: 4.6,
      reviewsCount: 2100,
      soldCount: 8900,
      status: ProductStatus.active,
      isFeatured: true,
      isBestSeller: true,
      freeShipping: false,
    ),
    Product(
      name: 'MacBook Pro 16"',
      slug: 'macbook-pro-16',
      description: 'Powerful laptop for professionals',
      storeId: 'store-1',
      storeName: 'Apple Store',
      category: 'Computers',
      subcategory: 'Laptops',
      brand: 'Apple',
      price: 280000,
      oldPrice: 320000,
      currency: 'KES',
      images: [],
      thumbnail: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
      sku: 'MACBOOK-PRO-16',
      rating: 4.9,
      reviewsCount: 450,
      soldCount: 950,
      status: ProductStatus.active,
      isFeatured: true,
      freeShipping: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 76;
    final gridCount = width < 60? 2 : width < 90 ? 1 : 2;
    final gridAspect = width < 60 ? 0.72 : width < 90 ? 0.45 : 0.22;

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
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
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
                            itemCount: _sampleProducts.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 160,
                                child: ProductCard(
                                  product: _sampleProducts[index],
                                  onTap: () => context.go('/product/${_sampleProducts[index].slug}'),
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
                          product: _sampleProducts[index % _sampleProducts.length],
                          onTap: () => context.go('/product/${_sampleProducts[index % _sampleProducts.length].slug}'),
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
                          product: _sampleProducts[index % _sampleProducts.length],
                          onTap: () => context.go('/product/${_sampleProducts[index % _sampleProducts.length].slug}'),
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
  final categories = [
    ('Electronics', '📱'),
    ('Fashion', '👔'),
    ('Phones', '📞'),
    ('Computers', '💻'),
    ('Furniture', '🛋️'),
    ('Gaming', '🎮'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final (name, emoji) = categories[index];
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
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
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
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now().add(const Duration(hours: 6));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _CountdownBox(label: 'Hours', value: '06'),
          const SizedBox(width: 8),
          _CountdownBox(label: 'Minutes', value: '45'),
          const SizedBox(width: 8),
          _CountdownBox(label: 'Seconds', value: '23'),
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

