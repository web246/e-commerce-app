import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wishlist_item.dart';

class WishlistProvider extends ChangeNotifier {
  static const _wishlistKey = 'dennis_mendez_wishlist';
  final SharedPreferences sharedPreferences;
  List<WishlistItem> _items = [];

  WishlistProvider(this.sharedPreferences) {
    _loadWishlist();
  }

  List<WishlistItem> get items => List.unmodifiable(_items);
  int get count => _items.length;

  Future<void> _loadWishlist() async {
    final data = sharedPreferences.getString(_wishlistKey);
    if (data != null && data.isNotEmpty) {
      final decoded = jsonDecode(data) as List<dynamic>;
      _items = decoded
          .map((item) => WishlistItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _saveWishlist() async {
    await sharedPreferences.setString(_wishlistKey, jsonEncode(_items.map((item) => item.toJson()).toList()));
  }

  Future<void> toggle(WishlistItem item) async {
    if (isWishlisted(item.productId)) {
      _items.removeWhere((existing) => existing.productId == item.productId);
    } else {
      _items.add(item);
    }
    await _saveWishlist();
    notifyListeners();
  }

  bool isWishlisted(String id) {
    return _items.any((item) => item.productId == id);
  }
}
