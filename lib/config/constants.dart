class AppConstants {
  static const appName = 'Vendi';
  static const defaultCurrency = 'KSh';
  static const defaultCurrencySymbol = 'KSh ';

  // Route paths
  static const routeHome = '/';
  static const routeLogin = '/login';
  static const routeRegister = '/register';
  static const routeForgotPassword = '/forgot-password';
  static const routeResetPassword = '/reset-password';
  static const routeOnboarding = '/onboarding';
  static const routeSplash = '/splash';
  static const routeCategories = '/categories';
  static const routeCart = '/cart';
  static const routeCheckout = '/checkout';
  static const routeOrders = '/orders';
  static const routeOrderSuccess = '/order-success';
  static const routeProfile = '/profile';
  static const routeWishlist = '/wishlist';
  static const routeSearch = '/search';
  static const routeBecomeSeller = '/become-seller';
  static const routeSellerDashboard = '/seller/dashboard';
  static const routeAdminDashboard = '/admin/dashboard';
  static String routeProduct(String id) => '/product/$id';
  static String routeCategory(String slug) => '/categories/$slug';

  // Supabase
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  // SharedPreferences keys
  static const prefsUserProfile = 'user_profile';
  static const prefsThemeMode = 'theme_mode';
  static const prefsSellerApplication = 'seller_application';
  static const prefsOrders = 'orders';
  static const prefsNotifications = 'notification_prefs';
  static const prefsLanguage = 'language_pref';
  static const prefsAddresses = 'saved_addresses';
  static const prefsCartPrefix = 'cart_';
  static const prefsWishlistPrefix = 'wishlist_';
  static const prefsOnboardingSeen = 'onboarding_seen';
  static const prefsEditName = 'edit_name';
  static const prefsEditPhone = 'edit_phone';

  // Seller/admin SharedPreferences keys
  static const prefsSellerTotalSales = 'seller_total_sales';
  static const prefsSellerOrderCount = 'seller_order_count';
  static const prefsSellerRating = 'seller_rating';
  static const prefsSellerProductCount = 'seller_product_count';
  static const prefsStoreName = 'store_name';

  static const prefsAdminTotalUsers = 'admin_total_users';
  static const prefsAdminTotalOrders = 'admin_total_orders';
  static const prefsAdminTotalRevenue = 'admin_total_revenue';
  static const prefsAdminTotalSellers = 'admin_total_sellers';
  static const prefsAdminRecentActivity = 'admin_recent_activity';

  // Coupons
  static const validCoupons = {
    'SAVE10': {'type': 'percent', 'value': 10, 'description': '10% off'},
    'WELCOME20': {
      'type': 'percent',
      'value': 20,
      'description': '20% off'
    },
    'FREESHIP': {
      'type': 'free_shipping',
      'value': 0,
      'description': 'Free shipping'
    },
    'FLAT500': {
      'type': 'fixed',
      'value': 500,
      'description': 'KSh 500 off'
    },
  };
}
