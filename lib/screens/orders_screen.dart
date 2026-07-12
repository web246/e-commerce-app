import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Order> orders = [
    Order(
      orderNumber: 'ORD-001',
      buyerId: 'user-1',
      buyerName: 'John Doe',
      buyerEmail: 'john@example.com',
      buyerPhone: '0700000000',
      subtotal: 50000,
      shippingFee: 150,
      total: 50150,
      status: OrderStatus.delivered,
      paymentStatus: PaymentStatus.paid,
      items: [{'name': 'iPhone 15 Pro', 'quantity': 1, 'price': 50000}],
      timeline: [
        {'status': 'Confirmed', 'timestamp': 'Jan 10, 2:30 PM'},
        {'status': 'Packed', 'timestamp': 'Jan 10, 4:00 PM'},
        {'status': 'Shipped', 'timestamp': 'Jan 11, 9:00 AM'},
        {'status': 'Out for Delivery', 'timestamp': 'Jan 12, 8:00 AM'},
        {'status': 'Delivered', 'timestamp': 'Jan 12, 5:30 PM'},
      ],
    ),
    Order(
      orderNumber: 'ORD-002',
      buyerId: 'user-1',
      buyerName: 'John Doe',
      buyerEmail: 'john@example.com',
      buyerPhone: '0700000000',
      subtotal: 25000,
      shippingFee: 150,
      total: 25150,
      status: OrderStatus.shipped,
      paymentStatus: PaymentStatus.paid,
      items: [{'name': 'Wireless Headphones', 'quantity': 1, 'price': 25000}],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Orders'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 64, color: AppTheme.mutedForeground),
              const SizedBox(height: 16),
              Text('No Orders Yet', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Start shopping to see orders here', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Browse Products'),
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
        title: const Text('Orders'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final statusColor = _getStatusColor(order.status);

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _OrderDetailSheet(order: order),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.orderNumber, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order.status.name.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${order.items.length} items', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: KES ${order.total.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const Icon(Icons.arrow_forward, color: AppTheme.mutedForeground),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.packed:
        return Colors.amber;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.outForDelivery:
        return Colors.orange;
      case OrderStatus.delivered:
        return Colors.green;
      default:
        return AppTheme.mutedForeground;
    }
  }
}

class _OrderDetailSheet extends StatelessWidget {
  final Order order;

  const _OrderDetailSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.muted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Order Timeline', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            if (order.timeline.isNotEmpty)
              Column(
                children: List.generate(
                  order.timeline.length,
                  (i) {
                    final step = order.timeline[i];
                    final isCompleted = i <= 1; // First 2 are completed for demo
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isCompleted ? Colors.green : AppTheme.muted,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: isCompleted ? Colors.white : AppTheme.mutedForeground,
                                    size: 14,
                                  ),
                                ),
                              ),
                              if (i < order.timeline.length - 1)
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: isCompleted ? Colors.green : AppTheme.muted,
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['status'] as String,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: isCompleted ? Colors.green : AppTheme.mutedForeground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  step['timestamp'] as String,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
