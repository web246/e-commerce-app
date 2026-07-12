import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showOTP = false;
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() {
      _errorMessage = null;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.register(_emailController.text.trim(), _passwordController.text);
      setState(() => _showOTP = true);
    } catch (error) {
      setState(() => _errorMessage = error.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _errorMessage = null;
    });
    final code = _otpControllers.map((controller) => controller.text.trim()).join();
    final email = context.read<AuthProvider>().pendingEmail ?? _emailController.text.trim();

    if (code.length != 6) {
      setState(() => _errorMessage = 'Enter the 6-digit code');
      return;
    }

    try {
      await context.read<AuthProvider>().verifyOtp(email, code);
      if (!mounted) return;
      context.go('/');
    } catch (error) {
      setState(() => _errorMessage = error.toString().replaceAll('Exception: ', ''));
    }
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
                  child: _showOTP ? _buildOTPForm() : _buildSignUpForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_errorMessage != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.destructive.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.destructive, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.destructive),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person_add, color: AppTheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Account',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Join Dennis Mendez today',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
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
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm password',
            prefixIcon: const Icon(Icons.lock_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: authProvider.isLoadingAuth ? null : _handleRegister,
                child: authProvider.isLoadingAuth
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : const Text('Create Account'),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account? '),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOTPForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_errorMessage != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.destructive.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.destructive, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.destructive),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.verified_user, color: AppTheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'Verify Email',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the 6-digit code sent to ${_emailController.text}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (i) => SizedBox(
              width: 45,
              child: TextField(
                controller: _otpControllers[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && i < 5) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: authProvider.isLoadingAuth ? null : _verifyOTP,
                child: authProvider.isLoadingAuth
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : const Text('Verify'),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () async {
            final email = context.read<AuthProvider>().pendingEmail ?? _emailController.text.trim();
            if (email.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter your email to resend code')));
              return;
            }
            try {
              await context.read<AuthProvider>().resendOtp(email);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code resent')));
            } catch (error) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString().replaceAll('Exception: ', ''))));
            }
          },
          child: const Text('Resend Code'),
        ),
      ],
    );
  }
}
