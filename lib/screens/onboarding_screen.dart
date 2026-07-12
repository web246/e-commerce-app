import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Shop Smarter',
      description: 'Discover thousands of products from your favorite brands, all in one place.',
      icon: Icons.shopping_bag,
      gradient: AppTheme.gradientPrimary,
      accentColor: AppTheme.primary,
    ),
    OnboardingPage(
      title: 'Fast & Secure Delivery',
      description: 'Get your orders delivered quickly and safely to your doorstep.',
      icon: Icons.local_shipping,
      gradient: AppTheme.gradientAccent,
      accentColor: AppTheme.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
                    child: const Text('Back'),
                  ),
                  TextButton(
                    onPressed: _currentPage < pages.length - 1 ? () => _completeOnboarding() : null,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: _OnboardingPageView(page: pages[index]),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == _currentPage ? 32 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: i == _currentPage ? AppTheme.primary : AppTheme.muted,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < pages.length - 1) {
                          _goToPage(_currentPage + 1);
                        } else {
                          _completeOnboarding();
                        }
                      },
                      child: Text(_currentPage < pages.length - 1 ? 'Continue' : 'Get Started'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final Color accentColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.accentColor,
  });
}

class _OnboardingPageView extends StatefulWidget {
  final OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  State<_OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<_OnboardingPageView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 288,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 288,
                height: 288,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: widget.page.gradient,
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.hydroShadow,
                    ),
                    child: Icon(widget.page.icon, color: widget.page.accentColor, size: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          widget.page.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.page.description,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.mutedForeground),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
