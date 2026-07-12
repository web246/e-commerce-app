import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class _DemoUser {
  final String email;
  final String password;
  final String role;
  final String name;

  const _DemoUser({
    required this.email,
    required this.password,
    required this.role,
    required this.name,
  });
}

class AuthProvider extends ChangeNotifier {
  static const _userProfileKey = 'user_profile';
  final SharedPreferences sharedPreferences;

  User? _user;
  bool _isAuthenticated = false;
  bool _isLoadingAuth = false;
  bool _authChecked = false;
  String? _pendingEmail;

  static const Map<String, _DemoUser> _demoUsers = {
    'admin@example.com': _DemoUser(
      email: 'admin@example.com',
      password: 'admin123',
      role: 'admin',
      name: 'Admin Demo',
    ),
    'seller@example.com': _DemoUser(
      email: 'seller@example.com',
      password: 'seller123',
      role: 'seller',
      name: 'Seller Demo',
    ),
    'customer@example.com': _DemoUser(
      email: 'customer@example.com',
      password: 'customer123',
      role: 'customer',
      name: 'Customer Demo',
    ),
    'slappygenius6@gmail.com': _DemoUser(
      email: 'slappygenius6@gmail.com',
      password: '12345678',
      role: 'customer',
      name: 'Slappy Genius',
    ),
  };

  AuthProvider(this.sharedPreferences) {
    _loadAuthState();
  }

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoadingAuth => _isLoadingAuth;
  bool get authChecked => _authChecked;
  String? get pendingEmail => _pendingEmail;

  bool get _hasSupabaseClient {
    try {
      sb.Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  sb.SupabaseClient get _client => sb.Supabase.instance.client;

  _DemoUser? _getDemoUser(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    final demoUser = _demoUsers[normalizedEmail];
    if (demoUser == null || demoUser.password != password) {
      return null;
    }
    return demoUser;
  }

  Future<void> _applyDemoUser(_DemoUser demoUser) async {
    _user = User(
      id: 'demo-${demoUser.role}',
      name: demoUser.name,
      email: demoUser.email,
      phone: '',
      role: demoUser.role,
      isVerified: true,
      avatarUrl: '',
    );
    await sharedPreferences.setString(_userProfileKey, jsonEncode(_user!.toJson()));
    _isAuthenticated = true;
    _pendingEmail = demoUser.email;
    notifyListeners();
  }

  Future<void> _loadAuthState() async {
    if (_hasSupabaseClient) {
      final session = _client.auth.currentSession;
      final authUser = _client.auth.currentUser;

      if (session != null && authUser != null) {
        _user = User(
          id: authUser.id,
          name: authUser.userMetadata?['name']?.toString() ?? authUser.email ?? 'User',
          email: authUser.email ?? '',
          phone: authUser.userMetadata?['phone']?.toString() ?? '',
          role: authUser.userMetadata?['role']?.toString() ?? 'customer',
          isVerified: authUser.emailConfirmedAt != null,
          avatarUrl: authUser.userMetadata?['avatarUrl']?.toString() ?? '',
        );
        sharedPreferences.setString(_userProfileKey, jsonEncode(_user!.toJson()));
        _isAuthenticated = true;
      } else {
        final userJson = sharedPreferences.getString(_userProfileKey);
        if (userJson != null) {
          _user = User.fromJson(jsonDecode(userJson));
          _isAuthenticated = false;
        }
      }
    } else {
      final userJson = sharedPreferences.getString(_userProfileKey);
      if (userJson != null) {
        _user = User.fromJson(jsonDecode(userJson));
      }
      _isAuthenticated = false;
    }

    _authChecked = true;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _isLoadingAuth = true;
    notifyListeners();

    try {
      final demoUser = _getDemoUser(email, password);
      if (demoUser != null) {
        await _applyDemoUser(demoUser);
        return;
      }

      final response = await _client.auth.signUp(email: email, password: password);

      _pendingEmail = email;
      _isAuthenticated = response.session != null;
      if (response.session != null && response.user != null) {
        final authUser = response.user!;
        _user = User(
          id: authUser.id,
          name: authUser.userMetadata?['name']?.toString() ?? authUser.email ?? 'User',
          email: authUser.email ?? email,
          phone: authUser.userMetadata?['phone']?.toString() ?? '',
          role: authUser.userMetadata?['role']?.toString() ?? 'customer',
          isVerified: authUser.emailConfirmedAt != null,
          avatarUrl: authUser.userMetadata?['avatarUrl']?.toString() ?? '',
        );
        sharedPreferences.setString(_userProfileKey, jsonEncode(_user!.toJson()));
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String email, String code) async {
    _isLoadingAuth = true;
    notifyListeners();

    try {
      if (!_hasSupabaseClient) {
        throw StateError('Supabase is not available right now');
      }

      final response = await _client.auth.verifyOTP(
        email: email,
        token: code,
        type: sb.OtpType.signup,
      );

      if (response.session != null && response.user != null) {
        final authUser = response.user!;
        _user = User(
          id: authUser.id,
          name: authUser.userMetadata?['name']?.toString() ?? authUser.email ?? 'User',
          email: authUser.email ?? email,
          phone: authUser.userMetadata?['phone']?.toString() ?? '',
          role: authUser.userMetadata?['role']?.toString() ?? 'customer',
          isVerified: authUser.emailConfirmedAt != null,
          avatarUrl: authUser.userMetadata?['avatarUrl']?.toString() ?? '',
        );
        sharedPreferences.setString(_userProfileKey, jsonEncode(_user!.toJson()));
        _isAuthenticated = true;
      } else {
        throw Exception('Verification did not complete authentication');
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  Future<void> resendOtp(String email) async {
    _isLoadingAuth = true;
    notifyListeners();

    try {
      if (!_hasSupabaseClient) {
        throw StateError('Supabase is not available right now');
      }

      await _client.auth.resend(
        type: sb.OtpType.signup,
        email: email,
      );

      _pendingEmail = email;
    } catch (error) {
      rethrow;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoadingAuth = true;
    notifyListeners();

    try {
      final demoUser = _getDemoUser(email, password);
      if (demoUser != null) {
        await _applyDemoUser(demoUser);
        return;
      }

      if (!_hasSupabaseClient) {
        throw StateError('Supabase is not available right now');
      }

      final response = await _client.auth.signInWithPassword(email: email, password: password);

      if (response.session != null && response.user != null) {
        final authUser = response.user!;
        _user = User(
          id: authUser.id,
          name: authUser.userMetadata?['name']?.toString() ?? authUser.email ?? 'User',
          email: authUser.email ?? email,
          phone: authUser.userMetadata?['phone']?.toString() ?? '',
          role: authUser.userMetadata?['role']?.toString() ?? 'customer',
          isVerified: authUser.emailConfirmedAt != null,
          avatarUrl: authUser.userMetadata?['avatarUrl']?.toString() ?? '',
        );
        sharedPreferences.setString(_userProfileKey, jsonEncode(_user!.toJson()));
        _isAuthenticated = true;
      } else {
        throw Exception('Login did not return a valid session');
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_hasSupabaseClient) {
      try {
        await _client.auth.signOut();
      } catch (_) {}
    }
    await sharedPreferences.remove(_userProfileKey);
    _user = null;
    _isAuthenticated = false;
    _pendingEmail = null;
    notifyListeners();
  }
}
