import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/products_provider.dart';
import 'providers/categories_provider.dart';
import 'providers/orders_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_success_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/search_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/become_seller_screen.dart';
import 'screens/seller/seller_dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://eqgkzawqqbomevmxnlqv.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_0OtkqDhtDJ33nrCRjf61pw_HMExE-eo',
  );

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (error, stackTrace) {
    debugPrint('Supabase initialization failed: $error');
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'main',
        context: ErrorDescription('Failed to initialize Supabase'),
      ),
    );
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(DennisMendezApp(sharedPreferences: sharedPreferences));
}

class DennisMendezApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const DennisMendezApp({required this.sharedPreferences, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(sharedPreferences)),
        ChangeNotifierProvider(create: (_) => AuthProvider(sharedPreferences)),
        ChangeNotifierProvider(create: (_) => CartProvider(sharedPreferences)),
        ChangeNotifierProvider(create: (_) => WishlistProvider(sharedPreferences)),
        ChangeNotifierProvider(create: (_) => ProductsProvider(sharedPreferences)),
        ChangeNotifierProvider(create: (_) => CategoriesProvider(sharedPreferences)),
        ChangeNotifierProvider(create: (_) => OrdersProvider(sharedPreferences)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Dennis Mendez',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _router(context),
          );
        },
      ),
    );
  }

  GoRouter _router(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
        GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
        GoRoute(path: '/reset-password', builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        }),
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/product/:id', builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(productId: id);
        }),
        GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
        GoRoute(path: '/checkout', builder: (context, state) => const CheckoutScreen()),
        GoRoute(path: '/order-success', builder: (context, state) {
          final orderNumber = state.uri.queryParameters['orderNumber'] ?? '';
          return OrderSuccessScreen(orderNumber: orderNumber);
        }),
        GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
        GoRoute(path: '/wishlist', builder: (context, state) => const WishlistScreen()),
        GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
        GoRoute(path: '/categories', builder: (context, state) => const CategoriesScreen()),
        GoRoute(path: '/categories/:slug', builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return SearchScreen(categorySlug: slug);
        }),
        GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        GoRoute(path: '/become-seller', builder: (context, state) => const BecomeSellerScreen()),
        GoRoute(path: '/seller', builder: (context, state) => const SellerDashboardScreen()),
        GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreen()),
      ],
      redirect: (context, state) {
        final location = state.uri.toString();
        const authFreePaths = ['/splash', '/onboarding', '/login', '/register', '/forgot-password', '/reset-password'];

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
}
