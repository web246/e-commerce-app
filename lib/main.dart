import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/config.dart';
import 'providers/providers.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

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
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter(context),
          );
        },
      ),
    );
  }
}
