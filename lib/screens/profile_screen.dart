import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _currentLanguage = 'English';
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final notifJson = prefs.getString(AppConstants.prefsNotifications);
    bool push = true;
    bool email = true;
    if (notifJson != null) {
      final map = jsonDecode(notifJson) as Map<String, dynamic>;
      push = map['push'] as bool? ?? true;
      email = map['email'] as bool? ?? true;
    }
    setState(() {
      _currentLanguage = prefs.getString(AppConstants.prefsLanguage) ?? 'English';
      _pushNotifications = push;
      _emailNotifications = email;
    });
  }

  void _showEditProfileDialog(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    final nameController = TextEditingController(text: user?.name ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(AppConstants.prefsEditName, nameController.text);
              await prefs.setString(AppConstants.prefsEditPhone, phoneController.text);
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated. Changes will apply on next login.'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddressesDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = prefs.getString(AppConstants.prefsAddresses);
    final addresses = addressesJson != null
        ? (jsonDecode(addressesJson) as List).cast<String>()
        : <String>[];

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Saved Addresses'),
        content: addresses.isEmpty
            ? const Text('No saved addresses yet.')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(addresses[i]),
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Payment Methods'),
        content: const Text(
          'Coming soon. You will be able to manage your payment methods here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Notification Preferences'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                value: _pushNotifications,
                onChanged: (v) async {
                  setDialogState(() => _pushNotifications = v);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                    AppConstants.prefsNotifications,
                    jsonEncode({'push': v, 'email': _emailNotifications}),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Email Notifications'),
                value: _emailNotifications,
                onChanged: (v) async {
                  setDialogState(() => _emailNotifications = v);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                    AppConstants.prefsNotifications,
                    jsonEncode({'push': _pushNotifications, 'email': v}),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Select Language'),
        children: [
          ListTile(
            leading: Icon(
              _currentLanguage == 'English'
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
            ),
            title: const Text('English'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(AppConstants.prefsLanguage, 'English');
              setState(() => _currentLanguage = 'English');
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
          ),
          ListTile(
            leading: Icon(
              _currentLanguage == 'Swahili'
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
            ),
            title: const Text('Swahili'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(AppConstants.prefsLanguage, 'Swahili');
              setState(() => _currentLanguage = 'Swahili');
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Help & FAQs'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How do I place an order?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Browse products, add items to your cart, and proceed to checkout.'),
              SizedBox(height: 16),
              Text('How do I track my order?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Go to Orders in your profile to see real-time order status.'),
              SizedBox(height: 16),
              Text('How do I return an item?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Contact support within 7 days of delivery to initiate a return.'),
              SizedBox(height: 16),
              Text('Need more help?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Contact our support team at support@example.com'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('E-Commerce App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 8),
            Text('A modern e-commerce platform built with Flutter.'),
            SizedBox(height: 8),
            Text('2024 E-Commerce App. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'We value your privacy. This is a placeholder privacy policy.\n\n'
            'Your data is stored securely and is never shared with third parties '
            'without your consent. We use your information to process orders, '
            'provide customer support, and improve our services.\n\n'
            'For the full privacy policy, please visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              color: AppTheme.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primary,
                    child: Text(
                      (user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : 'U'),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppTheme.mutedForeground),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified,
                            color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _ProfileListTile(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    subtitle: 'Update your information',
                    onTap: () => _showEditProfileDialog(context),
                  ),
                  _ProfileListTile(
                    icon: Icons.location_on,
                    title: 'Addresses',
                    subtitle: 'Manage delivery addresses',
                    onTap: () => _showAddressesDialog(context),
                  ),
                  _ProfileListTile(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Manage your payment info',
                    onTap: () => _showPaymentMethodsDialog(context),
                  ),
                  const SizedBox(height: 24),
                  // App Section
                  Text(
                    'App',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _ProfileListTile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: context.watch<ThemeProvider>().isDark,
                      onChanged: (_) =>
                          context.read<ThemeProvider>().toggleTheme(),
                    ),
                  ),
                  _ProfileListTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage alerts and updates',
                    onTap: () => _showNotificationsDialog(context),
                  ),
                  _ProfileListTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: _currentLanguage,
                    onTap: () => _showLanguageDialog(context),
                  ),
                  const SizedBox(height: 24),
                  // Support Section
                  Text(
                    'Support',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _ProfileListTile(
                    icon: Icons.help,
                    title: 'Help & FAQs',
                    onTap: () => _showHelpDialog(context),
                  ),
                  _ProfileListTile(
                    icon: Icons.info,
                    title: 'About App',
                    subtitle: 'Version 1.0.0',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _ProfileListTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    onTap: () => _showPrivacyPolicyDialog(context),
                  ),
                  const SizedBox(height: 24),
                  // Danger Zone
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout,
                          color: AppTheme.destructive),
                      label: const Text('Logout',
                          style: TextStyle(color: AppTheme.destructive)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AuthProvider>().logout();
                                  context.go('/login');
                                },
                                child: const Text('Logout',
                                    style:
                                        TextStyle(color: AppTheme.destructive)),
                              ),
                            ],
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.destructive),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_forever,
                          color: AppTheme.destructive),
                      label: const Text('Delete Account',
                          style: TextStyle(color: AppTheme.destructive)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _DeleteAccountDialog(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.destructive),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _ProfileListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    Text(title,
                        style: Theme.of(context).textTheme.titleLarge),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppTheme.mutedForeground),
                      ),
                  ],
                ),
              ),
              trailing ??
                  const Icon(Icons.arrow_forward,
                      color: AppTheme.mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account?'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'This action cannot be undone. All your data will be deleted including:'),
            const SizedBox(height: 12),
            const Text('• Your profile and personal information',
                style: TextStyle(fontSize: 12)),
            const Text('• Order history', style: TextStyle(fontSize: 12)),
            const Text('• Wishlist and saved items',
                style: TextStyle(fontSize: 12)),
            const Text('• Wallet and credits',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(
                  'I understand and want to delete my account'),
              value: _agree,
              onChanged: (value) =>
                  setState(() => _agree = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _agree
              ? () {
                  context.read<AuthProvider>().logout();
                  Navigator.pop(context);
                  context.go('/login');
                }
              : null,
          child: const Text('Delete',
              style: TextStyle(color: AppTheme.destructive)),
        ),
      ],
    );
  }
}
