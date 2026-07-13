import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

class TopBar extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;

  const TopBar({
    this.onSearchTap,
    this.onMenuTap,
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
    final cartProvider = context.watch<CartProvider>();
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width < 400) {
            return _buildCompactLayout(theme, cartProvider);
          } else if (width < 768) {
            return _buildMediumLayout(theme, cartProvider);
          } else {
            return _buildFullLayout(theme, cartProvider);
          }
        },
      ),
    );
  }

  Widget _buildCompactLayout(ThemeData theme, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          // Hamburger menu
          IconButton(
            icon: const Icon(Icons.menu, size: 22),
            onPressed: widget.onMenuTap,
            color: theme.colorScheme.onSurface,
            splashRadius: 20,
          ),
          const SizedBox(width: 4),
          // Logo text
          Text(
            'Duka',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          // Search icon
          IconButton(
            icon: const Icon(Icons.search, size: 22),
            onPressed: widget.onSearchTap,
            color: theme.colorScheme.onSurface,
            splashRadius: 20,
          ),
          // Cart with badge
          _IconWithBadge(
            icon: Icons.shopping_cart_outlined,
            onTap: widget.onCartTap,
            badge: cartProvider.itemCount > 0 ? cartProvider.itemCount : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMediumLayout(ThemeData theme, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Logo
          Text(
            'Duka',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          // Search field (compact)
          Expanded(
            child: GestureDetector(
              onTap: widget.onSearchTap,
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Search products...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Wishlist
          _IconWithBadge(
            icon: Icons.favorite_border,
            onTap: widget.onWishlistTap,
            badge: null,
          ),
          // Cart with badge
          _IconWithBadge(
            icon: Icons.shopping_cart_outlined,
            onTap: widget.onCartTap,
            badge: cartProvider.itemCount > 0 ? cartProvider.itemCount : null,
          ),
          // Avatar
          _AvatarButton(onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildFullLayout(ThemeData theme, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          // Logo
          Text(
            'Duka',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 24),
          // Full search field
          Expanded(
            child: GestureDetector(
              onTap: widget.onSearchTap,
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                    const SizedBox(width: 8),
                    Text(
                      'Search products...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    const Spacer(),
                    // Quick category chips inside search bar
                    ...['Electronics', 'Fashion', 'Home'].map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cat,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Wishlist
          _IconWithBadge(
            icon: Icons.favorite_border,
            onTap: widget.onWishlistTap,
            badge: null,
          ),
          // Notifications
          _IconWithBadge(
            icon: Icons.notifications_outlined,
            onTap: widget.onNotificationTap,
            badge: 2,
          ),
          // Cart
          _IconWithBadge(
            icon: Icons.shopping_cart_outlined,
            onTap: widget.onCartTap,
            badge: cartProvider.itemCount > 0 ? cartProvider.itemCount : null,
          ),
          // Avatar
          _AvatarButton(onTap: () {}),
        ],
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
    this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        onPressed: onTap,
        icon: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          children: [
            Icon(icon, size: 22, color: theme.colorScheme.onSurface),
            if (badge != null && badge! > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      badge! > 9 ? '9+' : badge.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        splashRadius: 20,
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AvatarButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        child: Icon(
          Icons.person_outline,
          size: 18,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
