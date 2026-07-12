import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Seller Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Sales',
                      value: 'KES 245,890',
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Orders',
                      value: '127',
                      icon: Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Ratings',
                      value: '4.8',
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Products',
                      value: '45',
                      icon: Icons.inventory,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Quick Actions
              Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.add,
                title: 'Add Product',
                onTap: () {},
              ),
              _ActionButton(
                icon: Icons.visibility,
                title: 'View Analytics',
                onTap: () {},
              ),
              _ActionButton(
                icon: Icons.settings,
                title: 'Store Settings',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              // Recent Orders
              Text('Recent Orders', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _OrderRow(
                      orderNumber: 'ORD-001',
                      items: '3 items',
                      total: 'KES 15,000',
                      status: 'Pending',
                      statusColor: Colors.orange,
                    ),
                    Divider(color: AppTheme.border),
                    _OrderRow(
                      orderNumber: 'ORD-002',
                      items: '1 item',
                      total: 'KES 5,000',
                      status: 'Shipped',
                      statusColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(width: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            const Icon(Icons.arrow_forward, color: AppTheme.mutedForeground),
          ],
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String orderNumber;
  final String items;
  final String total;
  final String status;
  final Color statusColor;

  const _OrderRow({
    required this.orderNumber,
    required this.items,
    required this.total,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderNumber, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text(items, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(total, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
