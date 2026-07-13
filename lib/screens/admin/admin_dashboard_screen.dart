import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _totalUsers = '0';
  String _totalOrders = '0';
  String _totalRevenue = 'KES 0';
  String _activeSellers = '0';
  List<Map<String, String>> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalUsers =
          prefs.getString(AppConstants.prefsAdminTotalUsers) ?? '0';
      _totalOrders =
          prefs.getString(AppConstants.prefsAdminTotalOrders) ?? '0';
      _totalRevenue =
          prefs.getString(AppConstants.prefsAdminTotalRevenue) ?? 'KES 0';
      _activeSellers =
          prefs.getString(AppConstants.prefsAdminTotalSellers) ?? '0';

      final activityJson =
          prefs.getString(AppConstants.prefsAdminRecentActivity);
      if (activityJson != null) {
        final list = jsonDecode(activityJson) as List;
        _recentActivity = list
            .map((e) =>
                Map<String, String>.from(e as Map))
            .toList();
      }
    });
  }

  void _showManageUsersDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manage Users'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'From here you will be able to:'),
            SizedBox(height: 8),
            Text('• View all registered users'),
            Text('• Ban or suspend accounts'),
            Text('• Reset user passwords'),
            Text('• View user activity logs'),
            Text('• Manage user roles'),
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

  void _showManageSellersDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manage Sellers'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'From here you will be able to:'),
            SizedBox(height: 8),
            Text(
                '• Review seller applications'),
            Text(
                '• Approve or reject applications'),
            Text(
                '• View seller performance'),
            Text(
                '• Manage seller payouts'),
            Text(
                '• Suspend seller accounts'),
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

  void _showManageProductsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manage Products'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'From here you will be able to:'),
            SizedBox(height: 8),
            Text(
                '• Review all product listings'),
            Text(
                '• Flag or remove inappropriate content'),
            Text(
                '• Verify product authenticity'),
            Text('• Manage categories'),
            Text('• View product analytics'),
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

  void _showReportsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reports'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'From here you will be able to:'),
            SizedBox(height: 8),
            Text('• View sales reports'),
            Text(
                '• Generate revenue statements'),
            Text('• Export data to CSV/PDF'),
            Text(
                '• View user growth trends'),
            Text(
                '• Monitor platform health'),
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Platform Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'From here you will be able to:'),
            SizedBox(height: 8),
            Text(
                '• Configure platform fees'),
            Text(
                '• Set commission rates'),
            Text(
                '• Manage payment gateways'),
            Text(
                '• Configure shipping options'),
            Text(
                '• Set platform policies'),
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadAdminData,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title:
                      const Text('Notifications'),
                  content: const Text(
                      'No new notifications.'),
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
      body: RefreshIndicator(
        onRefresh: _loadAdminData,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Global Stats
                Text('Platform Analytics',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total Users',
                        value: _totalUsers,
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Total Orders',
                        value: _totalOrders,
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
                        value: _totalRevenue,
                        icon: Icons.trending_up,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Active Sellers',
                        value: _activeSellers,
                        icon: Icons.store,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Management Sections
                Text('Management',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall),
                const SizedBox(height: 16),
                _ManagementButton(
                  icon: Icons.verified_user,
                  title: 'Manage Users',
                  subtitle:
                      'Review and manage user accounts',
                  count: _totalUsers,
                  onTap: _showManageUsersDialog,
                ),
                _ManagementButton(
                  icon: Icons.store,
                  title: 'Manage Sellers',
                  subtitle:
                      'Approve/reject seller applications',
                  count: _activeSellers,
                  onTap: _showManageSellersDialog,
                ),
                _ManagementButton(
                  icon: Icons.inventory,
                  title: 'Manage Products',
                  subtitle:
                      'Review and moderate products',
                  count: _totalOrders,
                  onTap: _showManageProductsDialog,
                ),
                _ManagementButton(
                  icon: Icons.report,
                  title: 'View Reports',
                  subtitle:
                      'Analytics and insights',
                  count: null,
                  onTap: _showReportsDialog,
                ),
                _ManagementButton(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle:
                      'Platform configuration',
                  count: null,
                  onTap: _showSettingsDialog,
                ),
                const SizedBox(height: 24),
                // Recent Activity
                Text('Recent Activity',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppTheme.border),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child:
                      _recentActivity.isEmpty
                          ? const Padding(
                              padding:
                                  EdgeInsets.all(24),
                              child: Center(
                                child: Text(
                                  'No recent activity',
                                  style: TextStyle(
                                      color: Colors
                                          .grey),
                                ),
                              ),
                            )
                          : Column(
                              children:
                                  _recentActivity
                                      .map(
                                          (activity) {
                                return Column(
                                  children: [
                                    _ActivityRow(
                                      icon: Icons
                                          .circle,
                                      title: activity[
                                              'title'] ??
                                          '',
                                      subtitle: activity[
                                                  'subtitle'] ??
                                              '',
                                      timestamp: activity[
                                                  'timestamp'] ??
                                              '',
                                      color: Colors
                                          .blue,
                                    ),
                                    Divider(
                                        color: AppTheme
                                            .border),
                                  ],
                                );
                              }).toList()),
                ),
              ],
            ),
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
                ?.copyWith(
                    color: AppTheme.mutedForeground),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                    fontWeight: FontWeight.bold),
          ),
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                            color:
                                AppTheme.mutedForeground),
                  ),
                ],
              ),
            ),
            if (count != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary
                      .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(4),
                ),
                child: Text(
                  count!,
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const Icon(Icons.arrow_forward,
                color: AppTheme.mutedForeground),
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
            child:
                Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                          color: AppTheme
                              .mutedForeground),
                ),
              ],
            ),
          ),
          Text(
            timestamp,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                    color: AppTheme.mutedForeground),
          ),
        ],
      ),
    );
  }
}
