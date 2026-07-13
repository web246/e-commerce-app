import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
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
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _showOTP = false;
  bool _isLoading = false;
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) _validateEmail();
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) _validatePassword();
    });
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) _validateConfirmPassword();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && !_emailRegex.hasMatch(email)) {
      setState(() { _emailError = 'Please enter a valid email address'; });
    } else {
      setState(() { _emailError = null; });
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
    if (password.isNotEmpty && password.length < 8) {
      setState(() { _passwordError = 'Password must be at least 8 characters'; });
    } else {
      setState(() { _passwordError = null; });
    }
  }

  void _validateConfirmPassword() {
    final confirm = _confirmPasswordController.text;
    if (confirm.isNotEmpty && confirm != _passwordController.text) {
      setState(() { _confirmPasswordError = 'Passwords do not match'; });
    } else {
      setState(() { _confirmPasswordError = null; });
    }
  }

  bool _validateAll() {
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();
    if (_emailError != null || _passwordError != null || _confirmPasswordError != null) {
      return false;
    }
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return false;
    }
    return true;
  }

  Future<void> _handleRegister() async {
    setState(() { _errorMessage = null; });
    if (!_validateAll()) return;

    setState(() { _isLoading = true; });
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.register(_emailController.text.trim(), _passwordController.text);
      if (!mounted) return;
      setState(() { _showOTP = true; _isLoading = false; });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _verifyOTP() async {
    setState(() { _errorMessage = null; });
    final code = _otpControllers.map((controller) => controller.text.trim()).join();
    final email = context.read<AuthProvider>().pendingEmail ?? _emailController.text.trim();

    if (code.length != 6) {
      setState(() => _errorMessage = 'Enter the 6-digit code');
      return;
    }

    setState(() { _isLoading = true; });
    try {
      await context.read<AuthProvider>().verifyOtp(email, code);
      if (!mounted) return;
      setState(() { _isLoading = false; });
      context.go('/');
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });
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
          'Join Vendi today',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedForeground),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          decoration: InputDecoration(
            hintText: 'Email address',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText: _emailError,
          ),
          onChanged: (_) {
            if (_emailError != null) setState(() { _emailError = null; });
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText: _passwordError,
          ),
          onChanged: (_) {
            if (_passwordError != null) setState(() { _passwordError = null; });
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm password',
            prefixIcon: const Icon(Icons.lock_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText: _confirmPasswordError,
          ),
          onChanged: (_) {
            if (_confirmPasswordError != null) setState(() { _confirmPasswordError = null; });
          },
        ),
        const SizedBox(height: 24),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final loading = _isLoading || authProvider.isLoadingAuth;
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: loading ? null : _handleRegister,
                child: loading
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
            final loading = _isLoading || authProvider.isLoadingAuth;
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: loading ? null : _verifyOTP,
                child: loading
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
