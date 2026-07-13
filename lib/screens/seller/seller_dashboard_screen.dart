import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../theme/app_theme.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  String _storeName = '';
  String _storeStatus = 'pending';
  String _totalSales = 'KES 0';
  String _orderCount = '0';
  String _rating = '0.0';
  String _productCount = '0';

  @override
  void initState() {
    super.initState();
    _loadSellerData();
  }

  Future<void> _loadSellerData() async {
    final prefs = await SharedPreferences.getInstance();
    final appJson = prefs.getString(AppConstants.prefsSellerApplication);
    if (appJson != null) {
      final data = jsonDecode(appJson) as Map<String, dynamic>;
      setState(() {
        _storeName = data['businessName']?.toString() ?? '';
        _storeStatus = data['status']?.toString() ?? 'pending';
      });
    }
    setState(() {
      _totalSales = prefs.getString(AppConstants.prefsSellerTotalSales) ?? 'KES 0';
      _orderCount = prefs.getString(AppConstants.prefsSellerOrderCount) ?? '0';
      _rating = prefs.getString(AppConstants.prefsSellerRating) ?? '0.0';
      _productCount = prefs.getString(AppConstants.prefsSellerProductCount) ?? '0';
    });
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Product'),
        content: const Text(
          'Coming soon — you\'ll be able to add products from the seller portal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Analytics'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Store Analytics',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Total Views: 0'),
            Text('Conversion Rate: 0%'),
            Text('Average Order Value: KES 0'),
            Text('Top Product: N/A'),
            SizedBox(height: 12),
            Text('Detailed analytics will be available soon.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showStoreSettingsDialog() {
    final nameController = TextEditingController(text: _storeName);
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Store Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Store Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                  labelText: 'Store Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                  AppConstants.prefsStoreName, nameController.text);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Store settings saved.')),
                );
              }
              _loadSellerData();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
            _storeName.isNotEmpty ? _storeName : 'Seller Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Notifications'),
                  content:
                      const Text('No new notifications.'),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(ctx),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _storeStatus == 'approved'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _storeStatus == 'approved'
                          ? Icons.check_circle
                          : Icons.hourglass_empty,
                      color: _storeStatus == 'approved'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _storeStatus == 'approved'
                          ? 'Your store is active'
                          : _storeStatus == 'rejected'
                              ? 'Application rejected'
                              : 'Application pending review',
                      style: TextStyle(
                        color: _storeStatus == 'approved'
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Sales',
                      value: _totalSales,
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Orders',
                      value: _orderCount,
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
                      value: _rating,
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Products',
                      value: _productCount,
                      icon: Icons.inventory,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Quick Actions
              Text('Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.add,
                title: 'Add Product',
                onTap: _showAddProductDialog,
              ),
              _ActionButton(
                icon: Icons.visibility,
                title: 'View Analytics',
                onTap: _showAnalyticsDialog,
              ),
              _ActionButton(
                icon: Icons.settings,
                title: 'Store Settings',
                onTap: _showStoreSettingsDialog,
              ),
              const SizedBox(height: 24),
              // Recent Orders
              Text('Recent Orders',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox,
                          size: 48,
                          color: AppTheme.mutedForeground),
                      const SizedBox(height: 8),
                      Text('No orders yet',
                          style: TextStyle(
                              color: AppTheme.mutedForeground)),
                    ],
                  ),
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
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.mutedForeground),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
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
            Text(title,
                style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            const Icon(Icons.arrow_forward,
                color: AppTheme.mutedForeground),
          ],
        ),
      ),
    );
  }
}
