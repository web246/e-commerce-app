import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';
import '../services/supabase_helper.dart';

/// Local emoji and color map for categories.
/// The Supabase categories table stores only name/slug/description,
/// so we maintain UI presentation data here.
const Map<String, _CategoryMeta> _defaultMeta = {
  'Electronics': _CategoryMeta('📱', '#0066FF'),
  'Fashion': _CategoryMeta('👔', '#FF6B9D'),
  'Phones': _CategoryMeta('📞', '#00B4D8'),
  'Computers': _CategoryMeta('💻', '#6366F1'),
  'Furniture': _CategoryMeta('🛋️', '#8B5CF6'),
  'Gaming': _CategoryMeta('🎮', '#EC4899'),
  'Beauty': _CategoryMeta('💄', '#F59E0B'),
  'Shoes': _CategoryMeta('👟', '#10B981'),
  'Groceries': _CategoryMeta('🛒', '#22C55E'),
  'Kitchen': _CategoryMeta('🍳', '#F97316'),
  'Automotive': _CategoryMeta('🚗', '#64748B'),
  'Health': _CategoryMeta('⚕️', '#EF4444'),
  'Sports': _CategoryMeta('⚽', '#3B82F6'),
  'More': _CategoryMeta('📦', '#8B5CF6'),
};

class _CategoryMeta {
  final String icon;
  final String color;
  const _CategoryMeta(this.icon, this.color);
}

class CategoriesProvider extends ChangeNotifier {
  static const _cacheKey = 'dennis_mendez_categories';

  final SharedPreferences sharedPreferences;

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  CategoriesProvider(this.sharedPreferences) {
    _loadCache();
  }

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _loadCache() {
    final raw = sharedPreferences.getString(_cacheKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _categories = decoded
            .map((j) => Category.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _saveCache() async {
    await sharedPreferences.setString(
      _cacheKey,
      jsonEncode(_categories.map((c) => c.toJson()).toList()),
    );
  }

  Future<void> fetchAll() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final client = supabaseClientOrNull;
      if (client == null) {
        _errorMessage = 'Supabase is not available right now';
        return;
      }

      final response = await client
          .from('categories')
          .select('*')
          .order('name');

      final converted = snakeToCamelList(response);
      _categories = converted.map((j) {
        final name = j['name'] as String? ?? '';
        final meta = _defaultMeta[name] ?? _CategoryMeta('📦', '#8B5CF6');
        // Merge DB fields with local presentation data
        final enriched = <String, dynamic>{
          ...j,
          'icon': meta.icon,
          'color': meta.color,
          'sortOrder': 0,
          'isActive': true,
        };
        return Category.fromJson(enriched);
      }).toList();

      await _saveCache();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
