import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/supabase_helper.dart';

class OrdersProvider extends ChangeNotifier {
  static const _cacheKey = 'dennis_mendez_orders';

  final SharedPreferences sharedPreferences;

  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  OrdersProvider(this.sharedPreferences) {
    _loadCache();
  }

  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _loadCache() {
    final raw = sharedPreferences.getString(_cacheKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _orders = decoded
            .map((j) => Order.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _saveCache() async {
    await sharedPreferences.setString(
      _cacheKey,
      jsonEncode(_orders.map((o) => o.toJson()).toList()),
    );
  }

  /// Fetch orders for a given buyer.
  Future<void> fetchMyOrders(String buyerId) async {
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
          .from('orders')
          .select('*')
          .eq('buyer_id', buyerId)
          .order('created_at', ascending: false);

      final converted = snakeToCamelList(response);
      _orders = converted.map((j) => Order.fromJson(j)).toList();
      await _saveCache();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new order from cart items and return it.
  /// Returns the created Order with the real order_number from Supabase.
  Future<Order> createOrder({
    required String buyerId,
    required String buyerName,
    required String buyerEmail,
    required String buyerPhone,
    required List<CartItem> cartItems,
    required Map<String, dynamic> shippingAddress,
    required DeliveryMethod deliveryMethod,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double shippingFee,
    String? couponCode,
  }) async {
    final client = supabaseClientOrNull;
    if (client == null) {
      throw StateError('Supabase is not available right now');
    }

    final tax = subtotal * 0.16; // 16% VAT
    final total = subtotal + shippingFee + tax;

    // Build the items array for the JSONB column.
    final items = cartItems.map((item) {
      return {
        'product_id': item.product.id,
        'name': item.product.name,
        'thumbnail': item.product.thumbnail,
        'price': item.product.price,
        'quantity': item.quantity,
        'store_id': item.product.storeId,
        'store_name': item.product.storeName,
      };
    }).toList();

    // Determine store info from the first cart item (simple marketplace model).
    final storeId = cartItems.isNotEmpty ? cartItems.first.product.storeId : '';
    final storeName = cartItems.isNotEmpty ? cartItems.first.product.storeName : '';

    // Initial timeline entry.
    final timeline = [
      {
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
        'label': 'Order placed',
      },
    ];

    // Build the insert map with snake_case keys directly.
    final data = <String, dynamic>{
      'buyer_id': buyerId,
      'buyer_name': buyerName,
      'buyer_email': buyerEmail,
      'buyer_phone': buyerPhone,
      'items': items,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'tax': tax,
      'discount': 0.0,
      'total': total,
      'currency': 'KES',
      'status': orderStatusToDb(OrderStatus.pending),
      'payment_method': paymentMethodToDb(paymentMethod),
      'payment_status': paymentStatusToDb(PaymentStatus.pending),
      'payment_reference': '',
      'shipping_address': shippingAddress,
      'delivery_method': deliveryMethodToDb(deliveryMethod),
      'tracking_number': '',
      'carrier': '',
      'coupon_code': couponCode ?? '',
      'store_id': storeId,
      'store_name': storeName,
      'timeline': timeline,
    };

    final response = await client
        .from('orders')
        .insert(data)
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Failed to create order');
    }

    final converted = snakeToCamel(response);
    final order = Order.fromJson(converted);

    // Prepend to local list and cache.
    _orders.insert(0, order);
    await _saveCache();
    notifyListeners();

    return order;
  }
}
