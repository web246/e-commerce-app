import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/common/product_card.dart';

class SearchScreen extends StatefulWidget {
  final String? categorySlug;

  const SearchScreen({this.categorySlug, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _sortBy = 'relevance';
  bool _freeShippingOnly = false;

  final List<Product> _sampleProducts = [
    Product(
      name: 'Premium Wireless Headphones',
      slug: 'premium-wireless-headphones',
      description: 'High-quality sound with noise cancellation',
      storeId: 'store-1',
      storeName: 'Electronics Pro',
      category: 'Electronics',
      subcategory: 'Audio',
      brand: 'AudioMax',
      price: 45000,
      oldPrice: 60000,
      currency: 'KES',
      images: [],
      thumbnail: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      sku: 'AUDIO-MAX-001',
      rating: 4.8,
      reviewsCount: 1250,
      soldCount: 3500,
      status: ProductStatus.active,
      freeShipping: true,
      isBestSeller: true,
    ),
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
      freeShipping: true,
      isBestSeller: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final gridCount = width < 600 ? 2 : width < 960 ? 3 : 4;
    final childAspectRatio = width < 600 ? 0.72 : width < 960 ? 0.74 : 0.80;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Search'),
      ),
      body: Row(
        children: [
          // Desktop Sidebar
          if (!isMobile)
            SizedBox(
              width: 256,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: AppTheme.border)),
                ),
                padding: const EdgeInsets.all(16),
                child: _buildFilters(),
              ),
            ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Search & Sort Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isMobile)
                        IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => _buildFilters(),
                            );
                          },
                        ),
                      if (!isMobile)
                        DropdownButton<String>(
                          value: _sortBy,
                          items: [
                            DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                            DropdownMenuItem(value: 'price_asc', child: Text('Price: Low to High')),
                            DropdownMenuItem(value: 'price_desc', child: Text('Price: High to Low')),
                            DropdownMenuItem(value: 'rating', child: Text('Top Rated')),
                            DropdownMenuItem(value: 'newest', child: Text('Newest')),
                          ],
                          onChanged: (value) => setState(() => _sortBy = value!),
                        ),
                    ],
                  ),
                ),
                // Product Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: _sampleProducts.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: _sampleProducts[index],
                      onTap: () => context.go('/product/${_sampleProducts[index].slug}'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => setState(() => _freeShippingOnly = false),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Free Shipping Only'),
            value: _freeShippingOnly,
            onChanged: (value) => setState(() => _freeShippingOnly = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 16),
          Text('Category', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...['Electronics', 'Fashion', 'Phones', 'Computers'].map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton(
                onPressed: () => context.go('/categories/$category'),
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                child: Text(category),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
