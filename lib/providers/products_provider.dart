import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../services/supabase_helper.dart';

class ProductsProvider extends ChangeNotifier {
  static const _cacheKey = 'dennis_mendez_products';

  final SharedPreferences sharedPreferences;

  List<Product> _featured = [];
  List<Product> _flashSale = [];
  List<Product> _trending = [];
  List<Product> _bestSellers = [];
  List<Product> _searchResults = [];
  List<Product> _categoryProducts = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;

  ProductsProvider(this.sharedPreferences) {
    _loadCache();
  }

  // -- public getters --

  List<Product> get featured => List.unmodifiable(_featured);
  List<Product> get flashSale => List.unmodifiable(_flashSale);
  List<Product> get trending => List.unmodifiable(_trending);
  List<Product> get bestSellers => List.unmodifiable(_bestSellers);
  List<Product> get searchResults => List.unmodifiable(_searchResults);
  List<Product> get categoryProducts => List.unmodifiable(_categoryProducts);
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // -- cache --

  void _loadCache() {
    final raw = sharedPreferences.getString(_cacheKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _featured = decoded
            .map((j) => Product.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _saveCache(List<Product> products) async {
    await sharedPreferences.setString(
      _cacheKey,
      jsonEncode(products.map((p) => p.toJson()).toList()),
    );
  }

  // -- fetch methods --

  Future<void> fetchFeatured() async {
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
          .from('products')
          .select('*')
          .eq('is_featured', true)
          .eq('status', 'active')
          .limit(20);

      final converted = snakeToCamelList(response);
      _featured = converted.map((j) => Product.fromJson(j)).toList();
      await _saveCache(_featured);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFlashSale() async {
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
          .from('products')
          .select('*')
          .eq('is_flash_sale', true)
          .eq('status', 'active')
          .gt('flash_sale_end', DateTime.now().toIso8601String())
          .limit(20);

      final converted = snakeToCamelList(response);
      _flashSale = converted.map((j) => Product.fromJson(j)).toList();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrending() async {
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
          .from('products')
          .select('*')
          .eq('status', 'active')
          .order('sold_count', ascending: false)
          .limit(20);

      final converted = snakeToCamelList(response);
      _trending = converted.map((j) => Product.fromJson(j)).toList();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBestSellers() async {
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
          .from('products')
          .select('*')
          .eq('is_best_seller', true)
          .eq('status', 'active')
          .limit(20);

      final converted = snakeToCamelList(response);
      _bestSellers = converted.map((j) => Product.fromJson(j)).toList();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchByCategory(String category) async {
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
          .from('products')
          .select('*')
          .eq('category', category)
          .eq('status', 'active')
          .limit(50);

      final converted = snakeToCamelList(response);
      _categoryProducts = converted.map((j) => Product.fromJson(j)).toList();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

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
          .from('products')
          .select('*')
          .ilike('name', '%$query%')
          .eq('status', 'active')
          .limit(50);

      final converted = snakeToCamelList(response);
      _searchResults = converted.map((j) => Product.fromJson(j)).toList();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductById(String id) async {
    _selectedProduct = null;
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
          .from('products')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        final converted = snakeToCamel(response);
        _selectedProduct = Product.fromJson(converted);
      } else {
        _errorMessage = 'Product not found';
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear search results (called when navigating away from search).
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  /// Clear the selected product detail.
  void clearSelection() {
    _selectedProduct = null;
  }
}
