import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/common/product_card.dart';
import '../providers/products_provider.dart';
import '../providers/categories_provider.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesProvider>().fetchAll();
      if (widget.categorySlug != null && widget.categorySlug!.isNotEmpty) {
        context.read<ProductsProvider>().fetchByCategory(widget.categorySlug!);
      }
    });
  }

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
    final productsProvider = context.watch<ProductsProvider>();
    final products = widget.categorySlug != null && widget.categorySlug!.isNotEmpty
        ? productsProvider.categoryProducts
        : productsProvider.searchResults;

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
                          onSubmitted: (value) => productsProvider.search(value),
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
                          onChanged: (value) {
                            setState(() => _sortBy = value!);
                            final query = _searchController.text;
                            if (query.isNotEmpty) {
                              productsProvider.search(query);
                            }
                          },
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
                    itemCount: products.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: products[index],
                      onTap: () => context.go('/product/${products[index].slug}'),
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
    final categoriesProvider = context.watch<CategoriesProvider>();
    final categories = categoriesProvider.categories.isNotEmpty
        ? categoriesProvider.categories.map((c) => c.name).toList()
        : ['Electronics', 'Fashion', 'Phones', 'Computers'];
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
          ...categories.map((category) {
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
