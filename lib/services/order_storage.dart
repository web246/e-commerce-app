import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../models/order.dart';

class OrderStorage {
  static Future<List<Order>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(AppConstants.prefsOrders) ?? [];
    return data.map((s) => Order.fromJson(jsonDecode(s))).toList();
  }

  static Future<void> saveOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await getOrders();
    orders.insert(0, order);
    final data = orders.map((o) => jsonEncode(o.toJson())).toList();
    await prefs.setStringList(AppConstants.prefsOrders, data);
  }

  static Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefsOrders);
  }
}
