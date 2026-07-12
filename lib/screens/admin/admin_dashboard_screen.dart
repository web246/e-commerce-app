import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Admin Dashboard'),
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
              // Global Stats
              Text('Platform Analytics', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Users',
                      value: '12,453',
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Total Orders',
                      value: '45,890',
                      icon: Icons.shopping_bag,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Revenue',
                      value: 'KES 5.2M',
                      icon: Icons.trending_up,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Active Sellers',
                      value: '382',
                      icon: Icons.store,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Management Sections
              Text('Management', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              _ManagementButton(
                icon: Icons.verified_user,
                title: 'Manage Users',
                subtitle: 'Review and manage user accounts',
                count: '12,453',
                onTap: () {},
              ),
              _ManagementButton(
                icon: Icons.store,
                title: 'Manage Sellers',
                subtitle: 'Approve/reject seller applications',
                count: '382',
                onTap: () {},
              ),
              _ManagementButton(
                icon: Icons.inventory,
                title: 'Manage Products',
                subtitle: 'Review and moderate products',
                count: '45,890',
                onTap: () {},
              ),
              _ManagementButton(
                icon: Icons.report,
                title: 'View Reports',
                subtitle: 'Analytics and insights',
                count: null,
                onTap: () {},
              ),
              _ManagementButton(
                icon: Icons.settings,
                title: 'Settings',
                subtitle: 'Platform configuration',
                count: null,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              // Recent Activity
              Text('Recent Activity', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _ActivityRow(
                      icon: Icons.person_add,
                      title: 'New seller registration',
                      subtitle: 'John\'s Electronics Pro Store',
                      timestamp: '2 hours ago',
                      color: Colors.blue,
                    ),
                    Divider(color: AppTheme.border),
                    _ActivityRow(
                      icon: Icons.report_problem,
                      title: 'Product flagged',
                      subtitle: 'Suspicious electronics listing',
                      timestamp: '4 hours ago',
                      color: Colors.orange,
                    ),
                    Divider(color: AppTheme.border),
                    _ActivityRow(
                      icon: Icons.check_circle,
                      title: 'Order completed',
                      subtitle: 'ORD-125489 delivered',
                      timestamp: '6 hours ago',
                      color: Colors.green,
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

class _ManagementButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? count;
  final VoidCallback onTap;

  const _ManagementButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.count,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
                ],
              ),
            ),
            if (count != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  count!,
                  style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            const Icon(Icons.arrow_forward, color: AppTheme.mutedForeground),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timestamp;
  final Color color;

  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
              ],
            ),
          ),
          Text(timestamp, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
        ],
      ),
    );
  }
}
