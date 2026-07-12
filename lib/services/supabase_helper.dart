import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../models/order.dart';
import '../models/product.dart';

/// Returns the Supabase client if initialized, null otherwise.
/// Mirrors the AuthProvider._hasSupabaseClient guard pattern.
sb.SupabaseClient? get supabaseClientOrNull {
  try {
    return sb.Supabase.instance.client;
  } catch (_) {
    return null;
  }
}

/// Recursively converts snake_case keys to camelCase.
/// Used on Supabase responses before passing to model fromJson().
Map<String, dynamic> snakeToCamel(Map<String, dynamic> data) {
  final result = <String, dynamic>{};
  for (final entry in data.entries) {
    final camelKey = entry.key.replaceAllMapped(
      RegExp(r'_([a-z])'),
      (m) => m.group(1)!.toUpperCase(),
    );
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      result[camelKey] = snakeToCamel(value);
    } else if (value is List) {
      result[camelKey] = _convertListSnakeToCamel(value);
    } else {
      result[camelKey] = value;
    }
  }
  return result;
}

/// Recursively converts camelCase keys to snake_case.
/// Used on model toJson() output before passing to Supabase insert/update.
Map<String, dynamic> camelToSnake(Map<String, dynamic> data) {
  final result = <String, dynamic>{};
  for (final entry in data.entries) {
    final snakeKey = entry.key.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '_${m.group(0)!.toLowerCase()}',
    );
    final value = entry.value;
    if (value is Map<String, dynamic>) {
      result[snakeKey] = camelToSnake(value);
    } else if (value is List) {
      result[snakeKey] = _convertListCamelToSnake(value);
    } else {
      result[snakeKey] = value;
    }
  }
  return result;
}

List<Map<String, dynamic>> snakeToCamelList(List<dynamic> data) {
  return data
      .map((item) => snakeToCamel(Map<String, dynamic>.from(item)))
      .toList();
}

List<Map<String, dynamic>> camelToSnakeList(List<dynamic> data) {
  return data
      .map((item) => camelToSnake(Map<String, dynamic>.from(item)))
      .toList();
}

List<dynamic> _convertListSnakeToCamel(List<dynamic> list) {
  return list.map((item) {
    if (item is Map<String, dynamic>) return snakeToCamel(item);
    if (item is List) return _convertListSnakeToCamel(item);
    return item;
  }).toList();
}

List<dynamic> _convertListCamelToSnake(List<dynamic> list) {
  return list.map((item) {
    if (item is Map<String, dynamic>) return camelToSnake(item);
    if (item is List) return _convertListCamelToSnake(item);
    return item;
  }).toList();
}

// ---------------------------------------------------------------------------
// Enum → DB string helpers
//
// The Dart enum .name values are camelCase (e.g. outForDelivery) but the DB
// stores snake_case (e.g. out_for_delivery). The model fromJson() methods
// already handle parsing snake_case DB values back to enums, so these helpers
// are only needed for WRITES.
// ---------------------------------------------------------------------------

String orderStatusToDb(OrderStatus status) {
  switch (status) {
    case OrderStatus.outForDelivery:
      return 'out_for_delivery';
    default:
      return status.name;
  }
}

String paymentMethodToDb(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.cashOnDelivery:
      return 'cash_on_delivery';
    default:
      return method.name;
  }
}

String paymentStatusToDb(PaymentStatus status) {
  return status.name; // pending, paid, failed, refunded — all single-word
}

String deliveryMethodToDb(DeliveryMethod method) {
  switch (method) {
    case DeliveryMethod.bodaExpress:
      return 'boda_express';
    default:
      return method.name; // standard, pickup
  }
}

String productStatusToDb(ProductStatus status) {
  switch (status) {
    case ProductStatus.outOfStock:
      return 'out_of_stock';
    case ProductStatus.pendingReview:
      return 'pending_review';
    default:
      return status.name; // active, inactive
  }
}

String productConditionToDb(ProductCondition condition) {
  switch (condition) {
    case ProductCondition.newCondition:
      return 'new';
    default:
      return condition.name; // used, refurbished
  }
}
