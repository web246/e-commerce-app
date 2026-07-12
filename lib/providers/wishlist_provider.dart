import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/wishlist_item.dart';
import '../services/supabase_helper.dart';

class WishlistProvider extends ChangeNotifier {
  static const _wishlistKey = 'dennis_mendez_wishlist';
  final SharedPreferences sharedPreferences;
  List<WishlistItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  WishlistProvider(this.sharedPreferences) {
    _loadLocal();
  }

  List<WishlistItem> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // -- local (SharedPreferences) operations --

  void _loadLocal() {
    final data = sharedPreferences.getString(_wishlistKey);
    if (data != null && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data) as List<dynamic>;
        _items = decoded
            .map((item) =>
                WishlistItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _saveLocal() async {
    await sharedPreferences.setString(
      _wishlistKey,
      jsonEncode(_items.map((item) => item.toJson()).toList()),
    );
  }

  // -- Supabase operations --

  /// Load wishlist from Supabase with a join on products for display data,
  /// falling back to SharedPreferences.
  Future<void> loadFromSupabase(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final client = supabaseClientOrNull;
      if (client == null) {
        return; // use local data
      }

      final response = await client
          .from('wishlist_items')
          .select('id, product_id, products!inner(name, thumbnail, price, store_name, store_id)')
          .eq('user_id', userId);

      if (response.isNotEmpty) {
        _items = response.map((row) {
          final product = row['products'] as Map<String, dynamic>? ?? {};
          return WishlistItem(
            productId: (row['product_id'] ?? '').toString(),
            productName: (product['name'] ?? '').toString(),
            productImage: (product['thumbnail'] ?? '').toString(),
            productPrice: ((product['price'] ?? 0) as num).toDouble(),
            storeId: (product['store_id'] ?? '').toString(),
            storeName: (product['store_name'] ?? '').toString(),
          );
        }).toList();

        await _saveLocal(); // sync to local cache
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add or remove an item from the wishlist.
  /// Tries Supabase first, always updates SharedPreferences.
  Future<void> toggle(String userId, WishlistItem item) async {
    if (isWishlisted(item.productId)) {
      // Remove.
      _items.removeWhere((existing) => existing.productId == item.productId);

      final client = supabaseClientOrNull;
      if (client != null) {
        try {
          await client
              .from('wishlist_items')
              .delete()
              .eq('user_id', userId)
              .eq('product_id', item.productId);
        } catch (_) {}
      }
    } else {
      // Add.
      _items.add(item);

      final client = supabaseClientOrNull;
      if (client != null) {
        try {
          await client.from('wishlist_items').insert({
            'user_id': userId,
            'product_id': item.productId,
          });
        } catch (_) {}
      }
    }

    await _saveLocal();
    notifyListeners();
  }

  bool isWishlisted(String id) {
    return _items.any((item) => item.productId == id);
  }
}
