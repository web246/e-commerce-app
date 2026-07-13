import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../models/wishlist_item.dart';

class WishlistProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  List<WishlistItem> _items = [];
  String? _userId;

  WishlistProvider(this.sharedPreferences) {
    _loadWishlist();
  }

  List<WishlistItem> get items => List.unmodifiable(_items);
  int get count => _items.length;

  String get _wishlistKey => '${AppConstants.prefsWishlistPrefix}${_userId ?? 'anonymous'}';

  Future<void> setUserId(String? userId) async {
    if (_userId == userId) return;
    await _saveWishlist();
    _userId = userId;
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    try {
      final data = sharedPreferences.getString(_wishlistKey);
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data) as List<dynamic>;
        _items = decoded
            .map((item) => WishlistItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {
      _items = [];
    }
    notifyListeners();
  }

  Future<void> _saveWishlist() async {
    await sharedPreferences.setString(_wishlistKey, jsonEncode(_items.map((item) => item.toJson()).toList()));
  }

  Future<void> toggle(String productId, WishlistItem? productData) async {
    if (isInWishlist(productId)) {
      _items.removeWhere((existing) => existing.productId == productId);
    } else if (productData != null) {
      _items.add(productData);
    }
    await _saveWishlist();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  Future<void> clearWishlist() async {
    _items.clear();
    await sharedPreferences.remove(_wishlistKey);
    notifyListeners();
  }
}
