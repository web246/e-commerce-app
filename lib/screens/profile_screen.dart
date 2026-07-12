import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final isMobile = MediaQuery.of(context).size.width < 768;

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
                      user?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'User', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        const Text('Verified', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
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
                  Text('Account', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _ProfileListTile(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    subtitle: 'Update your information',
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    icon: Icons.location_on,
                    title: 'Addresses',
                    subtitle: 'Manage delivery addresses',
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Manage your payment info',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  // App Section
                  Text('App', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _ProfileListTile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {},
                    ),
                  ),
                  _ProfileListTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage alerts and updates',
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  // Support Section
                  Text('Support', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _ProfileListTile(
                    icon: Icons.help,
                    title: 'Help & FAQs',
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    icon: Icons.info,
                    title: 'About App',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  // Danger Zone
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout, color: AppTheme.destructive),
                      label: const Text('Logout', style: TextStyle(color: AppTheme.destructive)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
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
                                child: const Text('Logout', style: TextStyle(color: AppTheme.destructive)),
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
                      icon: const Icon(Icons.delete_forever, color: AppTheme.destructive),
                      label: const Text('Delete Account', style: TextStyle(color: AppTheme.destructive)),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    if (subtitle != null)
                      Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedForeground)),
                  ],
                ),
              ),
              trailing ?? const Icon(Icons.arrow_forward, color: AppTheme.mutedForeground),
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
            const Text('This action cannot be undone. All your data will be deleted including:'),
            const SizedBox(height: 12),
            const Text('• Your profile and personal information', style: TextStyle(fontSize: 12)),
            const Text('• Order history', style: TextStyle(fontSize: 12)),
            const Text('• Wishlist and saved items', style: TextStyle(fontSize: 12)),
            const Text('• Wallet and credits', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('I understand and want to delete my account'),
              value: _agree,
              onChanged: (value) => setState(() => _agree = value ?? false),
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
          child: const Text('Delete', style: TextStyle(color: AppTheme.destructive)),
        ),
      ],
    );
  }
}
