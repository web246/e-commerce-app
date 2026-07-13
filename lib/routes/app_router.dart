import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/become_seller_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/home_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/order_success_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/seller/seller_dashboard_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/wishlist_screen.dart';
import '../widgets/layout/main_shell.dart';
import '../config/constants.dart';

GoRouter appRouter(BuildContext context) {
  final authProvider = context.read<AuthProvider>();

  return GoRouter(
    initialLocation: AppConstants.routeSplash,
    refreshListenable: authProvider,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppConstants.routeSplash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.routeOnboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.routeForgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppConstants.routeResetPassword,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.routeHome,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.routeCategories,
                builder: (context, state) => const CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.routeCart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.routeOrders,
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.routeProfile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: AppConstants.routeCheckout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppConstants.routeOrderSuccess,
        builder: (context, state) => const OrderSuccessScreen(),
      ),
      GoRoute(
        path: AppConstants.routeWishlist,
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSearch,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/categories/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return SearchScreen(categorySlug: slug);
        },
      ),
      GoRoute(
        path: AppConstants.routeBecomeSeller,
        builder: (context, state) => const BecomeSellerScreen(),
      ),
      GoRoute(
        path: '/seller',
        builder: (context, state) => const SellerDashboardScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      final location = state.uri.path;
      const authFreePaths = [
        AppConstants.routeSplash,
        AppConstants.routeOnboarding,
        AppConstants.routeLogin,
        AppConstants.routeRegister,
        AppConstants.routeForgotPassword,
        AppConstants.routeResetPassword,
      ];

      if (!authProvider.authChecked && location != '/splash') {
        return '/splash';
      }

      if (authFreePaths.contains(location)) {
        return null;
      }

      if (!authProvider.isAuthenticated) {
        return '/login';
      }

      if (location == '/admin' && authProvider.user?.role != 'admin') {
        return '/';
      }

      return null;
    },
    observers: [],
  );
}
