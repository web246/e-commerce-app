import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8).toUpperCase()}';

    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Checkmark Circle
                  ScaleTransition(
                    scale: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.check_circle, color: Colors.green, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
                      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
                    ),
                    child: Text(
                      'Order Placed!',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Order Number
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Order #$orderNumber',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Message
                  Text(
                    'Thank you for your purchase. Your order is being processed.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mutedForeground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Progress Steps
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _ProgressStep(
                          icon: Icons.check_circle,
                          title: 'Confirmed',
                          subtitle: 'Your order has been confirmed',
                          isActive: true,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(),
                        ),
                        _ProgressStep(
                          icon: Icons.inventory,
                          title: 'Packing',
                          subtitle: 'We are preparing your order',
                          isActive: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(),
                        ),
                        _ProgressStep(
                          icon: Icons.local_shipping,
                          title: 'Shipped',
                          subtitle: 'On the way to you',
                          isActive: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(),
                        ),
                        _ProgressStep(
                          icon: Icons.home,
                          title: 'Delivered',
                          subtitle: 'Package delivered',
                          isActive: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.go('/orders'),
                      child: const Text('Track Order'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Back to Home'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Support Message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You will receive email and SMS updates about your order',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isActive;

  const _ProgressStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: isActive ? Colors.green : AppTheme.mutedForeground,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isActive ? Colors.green : AppTheme.mutedForeground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive ? Colors.green : AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Current',
              style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
