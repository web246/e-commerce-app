import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
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
              const Icon(Icons.phone_android, size: 48, color: AppTheme.primary),
              const SizedBox(height: 16),
              const Text('Check Your Phone'),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('You will receive an STK push prompt on your phone'),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      Navigator.of(context).pop();
    }

    setState(() => _processing = false);
    await context.read<CartProvider>().clearCart();
    if (!mounted) return;
    context.go('/order-success');
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final isMobile = MediaQuery.of(context).size.width < 768;

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
                            color: i <= _currentStep ? AppTheme.primary : AppTheme.muted,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: i < _currentStep
                                ? const Icon(Icons.check, color: Colors.white, size: 20)
                                : Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      color: i <= _currentStep ? Colors.white : AppTheme.mutedForeground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        if (i < 3)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              height: 2,
                              color: i < _currentStep ? AppTheme.primary : AppTheme.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Step Content
              if (_currentStep == 0) _buildAddressStep() else if (_currentStep == 1) _buildDeliveryStep() else if (_currentStep == 2) _buildPaymentStep() else _buildReviewStep(cartProvider),
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
                      onPressed: _currentStep < 3 ? _nextStep : (_processing ? null : _placeOrder),
                      child: _processing ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_currentStep < 3 ? 'Continue' : 'Place Order'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Address', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Full Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _areaController,
          decoration: InputDecoration(
            hintText: 'Area / Street',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _townController,
          decoration: InputDecoration(
            hintText: 'Town / City',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _countyController,
          decoration: InputDecoration(
            hintText: 'County',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Method', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _DeliveryOption(
          title: 'Boda Express',
          subtitle: 'Get it today',
          price: 'KES 250',
          selected: _selectedDelivery == 'boda',
          onTap: () => setState(() => _selectedDelivery = 'boda'),
        ),
        const SizedBox(height: 12),
        _DeliveryOption(
          title: 'Standard',
          subtitle: '2-3 days delivery',
          price: 'KES 150',
          selected: _selectedDelivery == 'standard',
          onTap: () => setState(() => _selectedDelivery = 'standard'),
        ),
        const SizedBox(height: 12),
        _DeliveryOption(
          title: 'Self Pickup',
          subtitle: 'Pick up from store',
          price: 'FREE',
          selected: _selectedDelivery == 'pickup',
          onTap: () => setState(() => _selectedDelivery = 'pickup'),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _PaymentOption(
          title: 'M-Pesa',
          icon: Icons.payment,
          selected: _selectedPayment == 'mpesa',
          onTap: () => setState(() => _selectedPayment = 'mpesa'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          title: 'Card',
          icon: Icons.credit_card,
          selected: _selectedPayment == 'card',
          onTap: () => setState(() => _selectedPayment = 'card'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          title: 'PayPal',
          icon: Icons.account_balance_wallet,
          selected: _selectedPayment == 'paypal',
          onTap: () => setState(() => _selectedPayment = 'paypal'),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          title: 'Cash on Delivery',
          icon: Icons.money,
          selected: _selectedPayment == 'cod',
          onTap: () => setState(() => _selectedPayment = 'cod'),
        ),
      ],
    );
  }

  Widget _buildReviewStep(CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Review', style: Theme.of(context).textTheme.headlineSmall),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            Text('KES ${cartProvider.subtotal.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Delivery', style: Theme.of(context).textTheme.bodyMedium),
            Text(_selectedDelivery == 'pickup' ? 'FREE' : 'KES 150', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: AppTheme.border),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            Text(
              'KES ${(cartProvider.subtotal + (_selectedDelivery == 'pickup' ? 0 : 150)).toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primary),
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
  final bool selected;
  final VoidCallback onTap;

  const _DeliveryOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.border, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
          color: selected ? AppTheme.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio(
              value: title,
              groupValue: selected ? title : '',
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
                ],
              ),
            ),
            Text(price, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.border, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
          color: selected ? AppTheme.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio(
              value: title,
              groupValue: selected ? title : '',
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: selected ? AppTheme.primary : AppTheme.mutedForeground),
            const SizedBox(width: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
