import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../models/seller_application.dart';
import '../providers/providers.dart';
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
  bool _isLoading = false;
  SellerApplication? _existingApplication;

  @override
  void initState() {
    super.initState();
    _checkExistingApplication();
  }

  Future<void> _checkExistingApplication() async {
    final prefs = await SharedPreferences.getInstance();
    final appJson = prefs.getString(AppConstants.prefsSellerApplication);
    if (appJson != null) {
      setState(() {
        _existingApplication =
            SellerApplication.fromJson(jsonDecode(appJson));
      });
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _categoryController.dispose();
    _mpesaController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final application = SellerApplication(
        userId: authProvider.user?.id ?? '',
        businessName: _businessNameController.text,
        businessType: _businessType == 'individual'
            ? BusinessType.individual
            : _businessType == 'company'
                ? BusinessType.company
                : BusinessType.partnership,
        category: _categoryController.text,
        location: '',
        phone: _phoneController.text,
        email: _emailController.text,
        mpesaNumber: _mpesaController.text,
        description: '',
        status: SellerApplicationStatus.pending,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          AppConstants.prefsSellerApplication, jsonEncode(application.toJson()));

      if (!context.mounted) return;

      setState(() {
        _isLoading = false;
        _existingApplication = application;
      });

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Application Submitted'),
          content: const Text(
            'Your seller application has been submitted successfully. '
            'Our team will review it within 2-3 days.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.go('/seller');
              },
              child: const Text('Go to Dashboard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.go('/');
              },
              child: const Text('Home'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to submit application: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _existingApplication != null
              ? _buildExistingApplicationView()
              : SingleChildScrollView(
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
                                    color: i <= _step
                                        ? AppTheme.primary
                                        : AppTheme.muted,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        color: i <= _step
                                            ? Colors.white
                                            : AppTheme.mutedForeground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  i == 0
                                      ? 'Business'
                                      : i == 1
                                          ? 'Details'
                                          : 'Bank',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Form
                        if (_step == 0)
                          _buildBusinessForm()
                        else if (_step == 1)
                          _buildDetailsForm()
                        else
                          _buildBankForm(),
                        const SizedBox(height: 24),
                        // Navigation
                        Row(
                          children: [
                            if (_step > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      setState(() => _step--),
                                  child: const Text('Back'),
                                ),
                              ),
                            if (_step > 0) const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _step < 2
                                    ? () => setState(() => _step++)
                                    : _submitApplication,
                                child: Text(
                                    _step < 2 ? 'Continue' : 'Submit'),
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

  Widget _buildExistingApplicationView() {
    final app = _existingApplication!;
    final statusText = app.status == SellerApplicationStatus.pending
        ? 'Pending Review'
        : app.status == SellerApplicationStatus.underReview
            ? 'Under Review'
            : app.status == SellerApplicationStatus.approved
                ? 'Approved'
                : 'Rejected';
    final statusColor = app.status == SellerApplicationStatus.approved
        ? Colors.green
        : app.status == SellerApplicationStatus.rejected
            ? Colors.red
            : Colors.orange;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Center(
            child: Icon(Icons.store, size: 80, color: AppTheme.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Application Status',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Business', app.businessName),
          _buildInfoRow('Type', app.businessType.name),
          _buildInfoRow('Category', app.category),
          _buildInfoRow('Phone', app.phone),
          _buildInfoRow('Email', app.email),
          const SizedBox(height: 16),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  app.status == SellerApplicationStatus.approved
                      ? Icons.check_circle
                      : app.status == SellerApplicationStatus.rejected
                          ? Icons.cancel
                          : Icons.hourglass_empty,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildBusinessForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Information',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _businessType,
          items: const [
            DropdownMenuItem(
                value: 'individual', child: Text('Individual')),
            DropdownMenuItem(
                value: 'company', child: Text('Company')),
            DropdownMenuItem(
                value: 'partnership', child: Text('Partnership')),
          ],
          onChanged: (value) =>
              setState(() => _businessType = value ?? 'individual'),
          decoration: InputDecoration(
            labelText: 'Business Type',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _businessNameController,
          decoration: InputDecoration(
            labelText: 'Business Name',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _categoryController,
          decoration: InputDecoration(
            labelText: 'Primary Category',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildBankForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank & Payment',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _mpesaController,
          decoration: InputDecoration(
            labelText: 'M-Pesa Phone Number',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
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
                  'Your M-Pesa account will be verified. '
                  'You\'ll receive payouts twice monthly.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
