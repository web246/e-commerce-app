import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class TopBar extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;

  const TopBar({
    this.onSearchTap,
    this.onWishlistTap,
    this.onCartTap,
    this.onNotificationTap,
    super.key,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final cartProvider = context.watch<CartProvider>();
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final borderColor = Theme.of(context).dividerColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(color: borderColor.withOpacity(0.1)),
        ),
        boxShadow: AppTheme.hydroShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Logo
            Text(
              'D',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            // Search bar (desktop only)
            if (!isMobile) ...[
              Expanded(
                child: GestureDetector(
                  onTap: widget.onSearchTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Search products...',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ] else ...[
              const Spacer(),
            ],
            // Icons
            GestureDetector(
              onTap: isMobile ? widget.onSearchTap : null,
              child: Icon(
                Icons.search,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(width: 16),
            // Wishlist
            _IconWithBadge(
              icon: Icons.favorite_border,
              onTap: widget.onWishlistTap,
              badge: null,
            ),
            const SizedBox(width: 16),
            // Notifications
            _IconWithBadge(
              icon: Icons.notifications_outlined,
              onTap: widget.onNotificationTap,
              badge: 2,
            ),
            const SizedBox(width: 16),
            // Cart
            _IconWithBadge(
              icon: Icons.shopping_cart_outlined,
              onTap: widget.onCartTap,
              badge: cartProvider.itemCount > 0 ? cartProvider.itemCount : null,
            ),
            const SizedBox(width: 16),
            // User avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primary.withOpacity(0.2),
              child: const Icon(Icons.person, color: AppTheme.primary, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconWithBadge extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final int? badge;

  const _IconWithBadge({
    required this.icon,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Icon(icon, color: Theme.of(context).textTheme.bodyMedium?.color),
          if (badge != null && badge! > 0)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.destructive,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
