import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _navigateNext();
  }

  void _navigateNext() async {
    final authProvider = context.read<AuthProvider>();

    await Future.delayed(const Duration(seconds: 3));

    while (!authProvider.authChecked) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool(AppConstants.prefsOnboardingSeen) ?? false;

    if (!mounted) return;
    if (authProvider.isAuthenticated) {
      context.go('/');
    } else if (onboardingSeen) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradientHero),
        child: Stack(
          children: [
            _FloatingIcon(icon: Icons.shopping_bag, offset: Offset(20, 80), controller: _floatingController, delay: 0),
            _FloatingIcon(icon: Icons.local_shipping, offset: Offset(80, 200), controller: _floatingController, delay: 200),
            _FloatingIcon(icon: Icons.local_offer, offset: Offset(50, 350), controller: _floatingController, delay: 400),
            _FloatingIcon(icon: Icons.star, offset: Offset(100, 450), controller: _floatingController, delay: 100),
            _FloatingIcon(icon: Icons.local_shipping, offset: Offset(30, 550), controller: _floatingController, delay: 300),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'D',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ).animate(onInit: (controller) {
                    controller.repeat(reverse: true);
                  }).scale(duration: 2000.ms, begin: Offset(1, 1), end: Offset(1.1, 1.1)),
                  const SizedBox(height: 24),
                  const Text(
                    'Vendi',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Everything You Need, Delivered.',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  _LoadingDots(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Offset offset;
  final AnimationController controller;
  final int delay;

  const _FloatingIcon({
    required this.icon,
    required this.offset,
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 12), end: Offset(0, -12))
            .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
        child: Icon(icon, color: Colors.white.withOpacity(0.3), size: 32),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with TickerProviderStateMixin {
  late List<AnimationController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      3,
      (i) => AnimationController(duration: const Duration(milliseconds: 400), vsync: this)
        ..repeat(reverse: true),
    );

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].forward(from: (i * 200).toDouble() / 400.0);
    }
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => ScaleTransition(
          scale: Tween<double>(begin: 0.6, end: 1.0).animate(controllers[i]),
          child: Opacity(
            opacity: 0.6 + (controllers[i].value * 0.4),
            child: const SizedBox(
              width: 8,
              height: 8,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            ),
          ),
        ),
      ).separated(const SizedBox(width: 8)),
    );
  }
}

extension on List<Widget> {
  List<Widget> separated(Widget separator) {
    if (isEmpty) return this;
    return expand((w) => [w, separator]).toList()..removeLast();
  }
}
