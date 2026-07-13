import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  List<CartItem> _items = [];
  String? _userId;
  String? coupon;

  CartProvider(this.sharedPreferences) {
    _loadCart();
  }

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  String get _cartKey => '${AppConstants.prefsCartPrefix}${_userId ?? 'anonymous'}';

  Future<void> setUserId(String? userId) async {
    if (_userId == userId) return;
    await _saveCart();
    _userId = userId;
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final data = sharedPreferences.getString(_cartKey);
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data) as Map<String, dynamic>;
        coupon = decoded['coupon'] as String?;
        final itemsJson = decoded['items'] as List<dynamic>? ?? [];
        _items = itemsJson.map((item) => CartItem.fromJson(Map<String, dynamic>.from(item))).toList();
      }
    } catch (_) {
      _items = [];
      coupon = null;
    }
    notifyListeners();
  }

  Future<void> _saveCart() async {
    await sharedPreferences.setString(_cartKey, jsonEncode({
      'coupon': coupon,
      'items': _items.map((item) => item.toJson()).toList(),
    }));
  }

  Future<void> addItem(CartItem item) async {
    final existingIndex = _items.indexWhere((existing) => existing.key == item.key);
    if (existingIndex >= 0) {
      _items[existingIndex] = CartItem(
        key: _items[existingIndex].key,
        product: _items[existingIndex].product,
        quantity: _items[existingIndex].quantity + item.quantity,
        variant: _items[existingIndex].variant,
      );
    } else {
      _items.add(item);
    }
    await _saveCart();
    notifyListeners();
  }

  Future<void> removeItem(String key) async {
    _items.removeWhere((item) => item.key == key);
    await _saveCart();
    notifyListeners();
  }

  Future<void> updateQuantity(String key, int quantity) async {
    final index = _items.indexWhere((item) => item.key == key);
    if (index >= 0) {
      _items[index] = CartItem(
        key: _items[index].key,
        product: _items[index].product,
        quantity: quantity,
        variant: _items[index].variant,
      );
      await _saveCart();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    coupon = null;
    await sharedPreferences.remove(_cartKey);
    notifyListeners();
  }
}
