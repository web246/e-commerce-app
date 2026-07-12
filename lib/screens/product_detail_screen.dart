import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({required this.productId, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  int _quantity = 1;
  bool _addedToCart = false;
  late AnimationController _controller;

  final _fallbackProduct = Product(
    name: 'Premium Wireless Headphones',
    slug: 'premium-wireless-headphones',
    description: 'Experience superior sound quality with our premium wireless headphones. Featuring active noise cancellation, 30-hour battery life, and premium comfort design.',
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
    isFeatured: true,
    freeShipping: true,
    isBestSeller: true,
    specifications: {
      'Driver Size': '40mm',
      'Frequency Response': '20Hz - 20kHz',
      'Impedance': '32 Ohm',
      'Weight': '250g',
    },
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().getProductById(widget.productId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    final currentProduct = context.read<ProductsProvider>().selectedProduct ?? _fallbackProduct;
    final cartItem = CartItem(
      key: currentProduct.sku,
      product: currentProduct,
      quantity: _quantity,
    );
    context.read<CartProvider>().addItem(cartItem);
    setState(() => _addedToCart = true);
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _addedToCart = false);
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final productsProvider = context.watch<ProductsProvider>();
    if (productsProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (productsProvider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(productsProvider.errorMessage!, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }
    final product = productsProvider.selectedProduct ?? _fallbackProduct;
    final discount = ((product.oldPrice! - product.price) / product.oldPrice! * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: AppTheme.secondary,
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 64),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store
                  Row(
                    children: [
                      Text(product.storeName, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primary)),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(product.name, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(Icons.star, color: i < 4 ? Colors.amber : Colors.grey.withOpacity(0.3), size: 18)),
                      const SizedBox(width: 8),
                      Text('${product.rating}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Text('(${product.reviewsCount} reviews)', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
                      const SizedBox(width: 12),
                      Text('${product.soldCount} sold', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Price Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'KES ${product.price.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'KES ${product.oldPrice!.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppTheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.destructive.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Save $discount%',
                            style: const TextStyle(color: AppTheme.destructive, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Free Shipping Badge
                  if (product.freeShipping)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_shipping, color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Text('Free Shipping', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Quantity Selector
                  Row(
                    children: [
                      const Text('Quantity: '),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            ),
                            SizedBox(
                              width: 40,
                              child: Center(child: Text(_quantity.toString())),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Trust Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TrustBadge(icon: Icons.lock, label: 'Secure Payment'),
                      _TrustBadge(icon: Icons.timer, label: 'Fast Delivery'),
                      _TrustBadge(icon: Icons.assignment_return, label: 'Easy Returns'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // CTA Buttons
                  if (!isMobile)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart),
                            label: _addedToCart ? const Text('Added to Cart ✓') : const Text('Add to Cart'),
                            onPressed: _addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _addedToCart ? Colors.green : AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.go('/checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accent,
                            ),
                            child: const Text('Buy Now'),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart),
                            label: _addedToCart ? const Text('Added to Cart ✓') : const Text('Add to Cart'),
                            onPressed: _addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _addedToCart ? Colors.green : AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => context.go('/checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accent,
                            ),
                            child: const Text('Buy Now'),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Specifications
                  Text('Specifications', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  ...product.specifications.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground)),
                        Text(e.value.toString(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  // Description
                  Text('Description', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppTheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}
