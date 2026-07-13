import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/providers.dart';
import '../services/order_storage.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  String _selectedDelivery = 'standard';
  String _selectedPayment = 'mpesa';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _townController = TextEditingController();
  final _countyController = TextEditingController();
  final _mpesaController = TextEditingController();

  bool _processing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _townController.dispose();
    _countyController.dispose();
    _mpesaController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _placeOrder() async {
    setState(() => _processing = true);

    if (_selectedPayment == 'mpesa') {
      // Show M-Pesa modal
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('M-Pesa Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone_android,
                  size: 48, color: AppTheme.primary),
              const SizedBox(height: 16),
              const Text('Check Your Phone'),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                  'You will receive an STK push prompt on your phone'),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      Navigator.of(context).pop();
    }

    try {
      final cart = context.read<CartProvider>();
      final auth = context.read<AuthProvider>();

      final items = cart.items.map((item) => {
        'name': item.product.name,
        'quantity': item.quantity,
        'price': item.product.price,
      }).toList();

      final subtotal = cart.subtotal;
      double shippingFee = _selectedDelivery == 'pickup' ? 0.0 : 150.0;

      // Calculate coupon discount
      double discount = 0;
      if (cart.coupon != null && cart.coupon!.isNotEmpty) {
        const coupons = {
          'SAVE10': {'type': 'percent', 'value': 10},
          'WELCOME20': {'type': 'percent', 'value': 20},
          'FREESHIP': {'type': 'free_shipping', 'value': 0},
          'FLAT500': {'type': 'fixed', 'value': 500},
        };
        final couponData = coupons[cart.coupon];
        if (couponData != null) {
          switch (couponData['type']) {
            case 'percent':
              discount = subtotal * (couponData['value'] as int) / 100;
              break;
            case 'fixed':
              discount = (couponData['value'] as int).toDouble();
              break;
            case 'free_shipping':
              shippingFee = 0.0;
              break;
          }
        }
      }

      final double total =
          (subtotal + shippingFee - discount).clamp(0.0, double.infinity);

      // Map delivery method to enum
      DeliveryMethod deliveryMethod;
      switch (_selectedDelivery) {
        case 'boda':
          deliveryMethod = DeliveryMethod.bodaExpress;
          break;
        case 'pickup':
          deliveryMethod = DeliveryMethod.pickup;
          break;
        default:
          deliveryMethod = DeliveryMethod.standard;
      }

      // Map payment method to enum
      PaymentMethod paymentMethod;
      switch (_selectedPayment) {
        case 'card':
          paymentMethod = PaymentMethod.card;
          break;
        case 'paypal':
          paymentMethod = PaymentMethod.paypal;
          break;
        case 'cod':
          paymentMethod = PaymentMethod.cashOnDelivery;
          break;
        default:
          paymentMethod = PaymentMethod.mpesa;
      }

      final random = Random();
      final orderNumber =
          'ORD-${random.nextInt(99999).toString().padLeft(5, '0')}-${random.nextInt(9999).toString().padLeft(4, '0')}';

      DateTime estimatedDelivery;
      switch (_selectedDelivery) {
        case 'boda':
          estimatedDelivery = DateTime.now().add(const Duration(hours: 6));
          break;
        case 'pickup':
          estimatedDelivery = DateTime.now().add(const Duration(hours: 2));
          break;
        default:
          estimatedDelivery = DateTime.now().add(const Duration(days: 3));
      }

      final order = Order(
        orderNumber: orderNumber,
        buyerId: auth.user?.id ?? 'guest',
        buyerName: auth.user?.name ?? _nameController.text,
        buyerEmail: auth.user?.email ?? '',
        buyerPhone: _phoneController.text,
        items: items,
        subtotal: subtotal,
        shippingFee: shippingFee,
        tax: 0,
        discount: discount,
        total: total,
        status: OrderStatus.confirmed,
        paymentMethod: paymentMethod,
        paymentStatus: PaymentStatus.paid,
        shippingAddress: {
          'name': _nameController.text,
          'phone': _phoneController.text,
          'area': _areaController.text,
          'town': _townController.text,
          'county': _countyController.text,
        },
        deliveryMethod: deliveryMethod,
        estimatedDelivery: estimatedDelivery,
        couponCode: cart.coupon ?? '',
        timeline: [
          {
            'status': 'Confirmed',
            'timestamp': DateFormat('MMM d, h:mm a').format(DateTime.now()),
          },
        ],
      );

      await OrderStorage.saveOrder(order);

      setState(() => _processing = false);
      await cart.clearCart();
      if (!mounted) return;
      context.go('/order-success', extra: order);
    } catch (e) {
      setState(() => _processing = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: i <= _currentStep
                                ? AppTheme.primary
                                : AppTheme.muted,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: i < _currentStep
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 20)
                                : Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      color: i <= _currentStep
                                          ? Colors.white
                                          : AppTheme.mutedForeground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        if (i < 3)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              height: 2,
                              color: i < _currentStep
                                  ? AppTheme.primary
                                  : AppTheme.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Step Content
              if (_currentStep == 0)
                _buildAddressStep()
              else if (_currentStep == 1)
                _buildDeliveryStep()
              else if (_currentStep == 2)
                _buildPaymentStep()
              else
                _buildReviewStep(cartProvider),
              const SizedBox(height: 24),
              // Navigation Buttons
              Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentStep < 3
                          ? _nextStep
                          : (_processing ? null : _placeOrder),
                      child: _processing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2))
                          : Text(_currentStep < 3 ? 'Continue' : 'Place Order'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Address',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Full Name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _areaController,
            decoration: InputDecoration(
              hintText: 'Area / Street',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _townController,
            decoration: InputDecoration(
              hintText: 'Town / City',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _countyController,
            decoration: InputDecoration(
              hintText: 'County',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your county';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Method',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _DeliveryOption(
          title: 'Boda Express',
          subtitle: 'Get it today',
          price: 'KES 250',
          value: 'boda',
          groupValue: _selectedDelivery,
          onTap: () => setState(() => _selectedDelivery = 'boda'),
        ),
        const SizedBox(height: 12),
        _DeliveryOption(
          title: 'Standard',
          subtitle: '2-3 days delivery',
          price: 'KES 150',
          value: 'standard',
          groupValue: _selectedDelivery,
          onTap: () => setState(() => _selectedDelivery = 'standard'),
        ),
        const SizedBox(height: 12),
        _DeliveryOption(
          title: 'Self Pickup',
          subtitle: 'Pick up from store',
          price: 'FREE',
          value: 'pickup',
          groupValue: _selectedDelivery,
          onTap: () => setState(() => _selectedDelivery = 'pickup'),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _PaymentOption(
          title: 'M-Pesa',
          icon: Icons.payment,
          value: 'mpesa',
          groupValue: _selectedPayment,
          onTap: () => setState(() => _selectedPayment = 'mpesa'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          title: 'Card',
          icon: Icons.credit_card,
          value: 'card',
          groupValue: _selectedPayment,
          onTap: () => setState(() => _selectedPayment = 'card'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          title: 'PayPal',
          icon: Icons.account_balance_wallet,
          value: 'paypal',
          groupValue: _selectedPayment,
          onTap: () => setState(() => _selectedPayment = 'paypal'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          title: 'Cash on Delivery',
          icon: Icons.money,
          value: 'cod',
          groupValue: _selectedPayment,
          onTap: () => setState(() => _selectedPayment = 'cod'),
        ),
      ],
    );
  }

  Widget _buildReviewStep(CartProvider cartProvider) {
    const coupons = {
      'SAVE10': {'type': 'percent', 'value': 10},
      'WELCOME20': {'type': 'percent', 'value': 20},
      'FREESHIP': {'type': 'free_shipping', 'value': 0},
      'FLAT500': {'type': 'fixed', 'value': 500},
    };

    double discount = 0;
    bool freeShippingCoupon = false;
    if (cartProvider.coupon != null && cartProvider.coupon!.isNotEmpty) {
      final couponData = coupons[cartProvider.coupon];
      if (couponData != null) {
        switch (couponData['type']) {
          case 'percent':
            discount =
                cartProvider.subtotal * (couponData['value'] as int) / 100;
            break;
          case 'fixed':
            discount = (couponData['value'] as int).toDouble();
            break;
          case 'free_shipping':
            freeShippingCoupon = true;
            break;
        }
      }
    }

    final deliveryCost =
        (_selectedDelivery == 'pickup' || freeShippingCoupon) ? 0 : 150;
    final double total =
        (cartProvider.subtotal + deliveryCost - discount).clamp(0.0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Review',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ...cartProvider.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.product.name} x${item.quantity}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  'KES ${(item.product.price * item.quantity).toStringAsFixed(0)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
        Divider(color: AppTheme.border),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal',
                style: Theme.of(context).textTheme.bodyMedium),
            Text('KES ${cartProvider.subtotal.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        if (discount > 0) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text('-KES ${discount.toStringAsFixed(0)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.green)),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Delivery',
                style: Theme.of(context).textTheme.bodyMedium),
            Text(deliveryCost == 0 ? 'FREE' : 'KES $deliveryCost',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: AppTheme.border),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(
              'KES ${total.toStringAsFixed(0)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                      fontWeight: FontWeight.bold, color: AppTheme.primary),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _DeliveryOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected ? AppTheme.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.mutedForeground)),
                ],
              ),
            ),
            Text(price,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected ? AppTheme.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 8),
            Icon(icon,
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.mutedForeground),
            const SizedBox(width: 12),
            Text(title,
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
