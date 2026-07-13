import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../theme/app_theme.dart';

/// NOTE: This widget may be deprecated once main_shell.dart (which uses
/// a BottomNavigationBar inside a StatefulShellRoute) is fully integrated.
/// Keep this file for fallback / non-shell routes until migration is complete.

enum BottomNavTab { home, categories, cart, orders, profile }

class BottomNav extends StatefulWidget {
  final BottomNavTab currentTab;
  final Function(BottomNavTab) onTabChanged;

  const BottomNav({
    required this.currentTab,
    required this.onTabChanged,
    super.key,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late Offset _indicatorOffset;

  @override
  void initState() {
    super.initState();
    _updateIndicatorOffset();
  }

  @override
  void didUpdateWidget(BottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentTab != widget.currentTab) {
      _updateIndicatorOffset();
    }
  }

  void _updateIndicatorOffset() {
    final tabIndex = BottomNavTab.values.indexOf(widget.currentTab);
    _indicatorOffset = Offset(tabIndex.toDouble() * 60, 0);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor.withValues(alpha:0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: 0,
            left: _indicatorOffset.dx,
            child: Container(
              width: 60,
              height: 3,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                label: 'Home',
                icon: Icons.home_outlined,
                isActive: widget.currentTab == BottomNavTab.home,
                onTap: () => widget.onTabChanged(BottomNavTab.home),
              ),
              _BottomNavItem(
                label: 'Categories',
                icon: Icons.category_outlined,
                isActive: widget.currentTab == BottomNavTab.categories,
                onTap: () => widget.onTabChanged(BottomNavTab.categories),
              ),
              _BottomNavItem(
                label: 'Cart',
                icon: Icons.shopping_cart_outlined,
                isActive: widget.currentTab == BottomNavTab.cart,
                badge: cartProvider.itemCount > 0 ? cartProvider.itemCount : null,
                onTap: () => widget.onTabChanged(BottomNavTab.cart),
              ),
              _BottomNavItem(
                label: 'Orders',
                icon: Icons.assignment_outlined,
                isActive: widget.currentTab == BottomNavTab.orders,
                onTap: () => widget.onTabChanged(BottomNavTab.orders),
              ),
              _BottomNavItem(
                label: 'Profile',
                icon: Icons.person_outlined,
                isActive: widget.currentTab == BottomNavTab.profile,
                onTap: () => widget.onTabChanged(BottomNavTab.profile),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final int? badge;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurface.withValues(alpha:0.45);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(
                    icon,
                    color: isActive ? activeColor : inactiveColor,
                    size: 24,
                  ),
                  if (badge != null && badge! > 0)
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.destructive,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          badge.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isActive ? activeColor : inactiveColor,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
