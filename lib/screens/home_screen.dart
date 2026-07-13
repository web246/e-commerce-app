import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/product_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gridCount = width < 600 ? 2 : width < 960 ? 3 : 4;
    final gridAspect = width < 600 ? 0.72 : width < 960 ? 0.74 : 0.80;

    final flashSaleProducts = ProductRepository.getFlashSale();
    final featuredProducts = ProductRepository.getFeatured();
    final bestSellerProducts = ProductRepository.getBestSellers();

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
              onRefresh: () async =>
                  await Future.delayed(const Duration(seconds: 1)),
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
                        if (flashSaleProducts.isNotEmpty) ...[
                          SectionHeader(
                            title: 'Flash Sale',
                            badge: '\u{1F525} 6h left',
                            onViewAll: () => context.go('/search'),
                          ),
                          const SizedBox(height: 12),
                          const _FlashSaleCountdown(),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: flashSaleProducts.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SizedBox(
                                  width: 160,
                                  child: ProductCard(
                                    product: flashSaleProducts[index],
                                    onTap: () => context.go(
                                        '/product/${flashSaleProducts[index].slug}'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ]),
                    ),
                  ),
                  // Trending Now
                  if (featuredProducts.isNotEmpty)
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Trending Now',
                        onViewAll: () => context.go('/search'),
                      ),
                    ),
                  if (featuredProducts.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: gridAspect,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ProductCard(
                            product: featuredProducts[index],
                            onTap: () => context.go(
                                '/product/${featuredProducts[index].slug}'),
                          ),
                          childCount: featuredProducts.length > 8
                              ? 8
                              : featuredProducts.length,
                        ),
                      ),
                    ),
                  // Best Sellers
                  if (bestSellerProducts.isNotEmpty)
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Best Sellers',
                        onViewAll: () => context.go('/search'),
                      ),
                    ),
                  if (bestSellerProducts.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: gridAspect,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ProductCard(
                            product: bestSellerProducts[index],
                            onTap: () => context.go(
                                '/product/${bestSellerProducts[index].slug}'),
                          ),
                          childCount: bestSellerProducts.length > 8
                              ? 8
                              : bestSellerProducts.length,
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
      height: 200,
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
    ('Electronics', '\u{1F4F1}'),
    ('Fashion', '\u{1F454}'),
    ('Phones', '\u{1F4DE}'),
    ('Computers', '\u{1F4BB}'),
    ('Furniture', '\u{1F6CB}\u{FE0F}'),
    ('Gaming', '\u{1F3AE}'),
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
                      color: AppTheme.categoryColors[name]
                              ?.withOpacity(0.15) ??
                          AppTheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child:
                          Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
  const _FlashSaleCountdown();

  @override
  State<_FlashSaleCountdown> createState() => _FlashSaleCountdownState();
}

class _FlashSaleCountdownState extends State<_FlashSaleCountdown> {
  late Timer _countdownTimer;
  Duration _remaining = const Duration(hours: 6, minutes: 45, seconds: 23);

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours.toString().padLeft(2, '0');
    final minutes =
        _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.mutedForeground),
          ),
        ],
      ),
    );
  }
}
