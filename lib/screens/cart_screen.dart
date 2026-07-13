import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  String? _appliedCouponCode;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _validCoupons = {
      'SAVE10': {'type': 'percent', 'value': 10, 'description': '10% off'},
      'WELCOME20': {'type': 'percent', 'value': 20, 'description': '20% off'},
      'FREESHIP': {'type': 'free_shipping', 'value': 0, 'description': 'Free shipping'},
      'FLAT500': {'type': 'fixed', 'value': 500, 'description': 'KSh 500 off'},
    };

    final cartProvider = context.watch<CartProvider>();

    // Compute discount from applied coupon
    double discountAmount = 0;
    bool freeShipping = false;
    String? appliedDesc;
    if (_appliedCouponCode != null) {
      final coupon = _validCoupons[_appliedCouponCode];
      if (coupon != null) {
        appliedDesc = coupon['description'] as String;
        switch (coupon['type']) {
          case 'percent':
            discountAmount = cartProvider.subtotal * (coupon['value'] as int) / 100;
            break;
          case 'fixed':
            discountAmount = (coupon['value'] as int).toDouble();
            break;
          case 'free_shipping':
            freeShipping = true;
            break;
        }
      }
    }

    final double shippingCost =
        freeShipping ? 0 : (cartProvider.subtotal >= 2000 ? 0 : 150);
    final double finalTotal =
        (cartProvider.subtotal - discountAmount + shippingCost)
            .clamp(0, double.infinity);

    if (cartProvider.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Cart'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined,
                  size: 64, color: AppTheme.mutedForeground),
              const SizedBox(height: 16),
              Text(
                'Your Cart is Empty',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Add items to get started',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppTheme.mutedForeground),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Start Shopping'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart Items
              ...cartProvider.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            item.product.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.storeName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppTheme.primary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.product.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'KES ${item.product.price.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.border),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: item.quantity > 1
                                        ? () => cartProvider.updateQuantity(
                                            item.key, item.quantity - 1)
                                        : null,
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Center(
                                        child: Text(item.quantity.toString())),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () => cartProvider.updateQuantity(
                                        item.key, item.quantity + 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppTheme.destructive, size: 20),
                              onPressed: () =>
                                  cartProvider.removeItem(item.key),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
              // Coupon
              Text('Promo Code',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final code =
                          _couponController.text.trim().toUpperCase();
                      if (code.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please enter a coupon code')),
                        );
                        return;
                      }
                      final coupon = _validCoupons[code];
                      if (coupon == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invalid coupon code')),
                        );
                        return;
                      }
                      setState(() {
                        _appliedCouponCode = code;
                      });
                      final cart = context.read<CartProvider>();
                      cart.coupon = code;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Coupon applied: ${coupon['description']}'),
                        ),
                      );
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
              if (_appliedCouponCode != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Coupon "$_appliedCouponCode" applied ($appliedDesc)',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Order Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Summary',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Subtotal',
                      value:
                          'KES ${cartProvider.subtotal.toStringAsFixed(0)}',
                    ),
                    if (discountAmount > 0) ...[
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Discount',
                        value:
                            '-KES ${discountAmount.toStringAsFixed(0)}',
                      ),
                    ],
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Shipping',
                      value: freeShipping || cartProvider.subtotal >= 2000
                          ? 'FREE'
                          : 'KES 150',
                    ),
                    const SizedBox(height: 8),
                    Divider(color: AppTheme.border),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Total',
                      value: 'KES ${finalTotal.toStringAsFixed(0)}',
                      isBold: true,
                    ),
                    if (!freeShipping && cartProvider.subtotal < 2000)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Free shipping on orders over KES 2000',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/checkout'),
                  child: const Text('Proceed to Checkout'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: isBold
              ? Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
