import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../services/product_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

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

  List<Product> get _baseProducts {
    if (widget.categorySlug != null && widget.categorySlug!.isNotEmpty) {
      return ProductRepository.getByCategory(widget.categorySlug!);
    }
    return ProductRepository.getAll();
  }

  List<Product> get _filteredProducts {
    final base = _baseProducts;

    // Apply search query filter
    final query = _searchController.text.toLowerCase().trim();
    List<Product> results;
    if (query.isEmpty) {
      results = base;
    } else {
      results = base
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.storeName.toLowerCase().contains(query) ||
              p.category.toLowerCase().contains(query))
          .toList();
    }

    // Apply free shipping filter
    if (_freeShippingOnly) {
      results = results.where((p) => p.freeShipping).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'price_asc':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        results = results.reversed.toList();
        break;
      default:
        break;
    }

    return results;
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

    final results = _filteredProducts;
    final isEmpty = results.isEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.categorySlug != null
            ? widget.categorySlug!
            : 'Search'),
      ),
      body: Row(
        children: [
          // Desktop Sidebar
          if (!isMobile)
            SizedBox(
              width: 256,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border(right: BorderSide(color: AppTheme.border)),
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (_) => setState(() {}),
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
                            DropdownMenuItem(
                                value: 'relevance',
                                child: Text('Relevance')),
                            DropdownMenuItem(
                                value: 'price_asc',
                                child: Text('Price: Low to High')),
                            DropdownMenuItem(
                                value: 'price_desc',
                                child: Text('Price: High to Low')),
                            DropdownMenuItem(
                                value: 'rating',
                                child: Text('Top Rated')),
                            DropdownMenuItem(
                                value: 'newest',
                                child: Text('Newest')),
                          ],
                          onChanged: (value) =>
                              setState(() => _sortBy = value!),
                        ),
                    ],
                  ),
                ),
                // Product Grid / Empty State
                Expanded(
                  child: isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off,
                                  size: 64,
                                  color: AppTheme.mutedForeground),
                              const SizedBox(height: 16),
                              Text(
                                'No results found',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search terms',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color:
                                            AppTheme.mutedForeground),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: results.length,
                          itemBuilder: (context, index) => ProductCard(
                            product: results[index],
                            onTap: () =>
                                context.go('/product/${results[index].slug}'),
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
              Text('Filters',
                  style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () =>
                    setState(() => _freeShippingOnly = false),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Free Shipping Only'),
            value: _freeShippingOnly,
            onChanged: (value) =>
                setState(() => _freeShippingOnly = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 16),
          Text('Category',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...['Electronics', 'Fashion', 'Phones', 'Computers'].map(
              (category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton(
                onPressed: () => context.go('/categories/$category'),
                style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft),
                child: Text(category),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
