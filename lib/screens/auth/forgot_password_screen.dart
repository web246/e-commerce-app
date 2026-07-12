import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.hydroShadow,
                  ),
                  padding: const EdgeInsets.all(32),
                  child: _submitted ? _buildSuccessState() : _buildFormState(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.lock_reset, color: AppTheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email and we\'ll send a reset link',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Email address',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('Send Reset Link'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.check_circle, color: Colors.green, size: 40),
        ),
        const SizedBox(height: 16),
        Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ve sent a password reset link to ${_emailController.text}. Follow the link to create a new password.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Back to Sign In'),
          ),
        ),
      ],
    );
  }
}
