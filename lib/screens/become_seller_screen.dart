import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class BecomeSellerScreen extends StatefulWidget {
  const BecomeSellerScreen({super.key});

  @override
  State<BecomeSellerScreen> createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen> {
  int _step = 0;
  final _businessNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _categoryController = TextEditingController();
  final _mpesaController = TextEditingController();
  String _businessType = 'individual';

  @override
  void dispose() {
    _businessNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _categoryController.dispose();
    _mpesaController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    // Simulate submission
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Application Submitted'),
        content: const Text('Your seller application has been submitted. Our team will review it within 2-3 days.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
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
        title: const Text('Become a Seller'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (i) => Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: i <= _step ? AppTheme.primary : AppTheme.muted,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: i <= _step ? Colors.white : AppTheme.mutedForeground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        i == 0 ? 'Business' : i == 1 ? 'Details' : 'Bank',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Form
              if (_step == 0) _buildBusinessForm() else if (_step == 1) _buildDetailsForm() else _buildBankForm(),
              const SizedBox(height: 24),
              // Navigation
              Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _step < 2 ? () => setState(() => _step++) : _submitApplication,
                      child: Text(_step < 2 ? 'Continue' : 'Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Information', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _businessType,
          items: [
            DropdownMenuItem(value: 'individual', child: const Text('Individual')),
            DropdownMenuItem(value: 'company', child: const Text('Company')),
            DropdownMenuItem(value: 'partnership', child: const Text('Partnership')),
          ],
          onChanged: (value) => setState(() => _businessType = value ?? 'individual'),
          decoration: InputDecoration(
            labelText: 'Business Type',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _businessNameController,
          decoration: InputDecoration(
            labelText: 'Business Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _categoryController,
          decoration: InputDecoration(
            labelText: 'Primary Category',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildBankForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bank & Payment', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _mpesaController,
          decoration: InputDecoration(
            labelText: 'M-Pesa Phone Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your M-Pesa account will be verified. You\'ll receive payouts twice monthly.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
