import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/wishlist_item.dart';
import '../../providers/wishlist_provider.dart';
import '../../theme/app_theme.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    required this.product,
    this.onTap,
    this.onAddToCart,
    super.key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
     final isWishlisted = wishlistProvider.isWishlisted(widget.product.name);
     final displayPrice = widget.product.price;
     final oldPrice = widget.product.oldPrice ?? widget.product.price;
     final discount = ((oldPrice - displayPrice) / oldPrice * 100).toInt();

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 0.95).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.secondary,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Image.network(
                         widget.product.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppTheme.muted,
                          child: const Icon(Icons.image, color: AppTheme.mutedForeground),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Column(
                      children: [
                        if (discount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppTheme.gradientAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-$discount%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (widget.product.isBestSeller)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Best Seller',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                         final wishlistItem = WishlistItem(
                           productId: widget.product.name,
                           productName: widget.product.name,
                           productImage: widget.product.thumbnail,
                           productPrice: widget.product.price,
                           storeId: widget.product.storeId,
                           storeName: widget.product.storeName,
                        );
                        context.read<WishlistProvider>().toggle(wishlistItem);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : AppTheme.mutedForeground,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.product.storeName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            Text(
                              '${widget.product.rating}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '(${widget.product.reviewsCount})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Flexible(
                              child: Text(
                                'KES ${widget.product.price.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.product.oldPrice != null)
                              Text(
                                'KES ${widget.product.oldPrice!.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme.mutedForeground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        if (widget.product.freeShipping) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                const Icon(Icons.local_shipping, color: Colors.green, size: 14),
                                Text(
                                  'Free Shipping',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
