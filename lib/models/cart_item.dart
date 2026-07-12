import 'product.dart';

class CartItem {
  final String key;
  final Product product;
  final int quantity;
  final Map<String, dynamic>? variant;

  CartItem({
    required this.key,
    required this.product,
    this.quantity = 1,
    this.variant,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      key: json['key'] ?? '',
      product: Product.fromJson(Map<String, dynamic>.from(json['product'] ?? {})),
      quantity: json['quantity'] ?? 1,
      variant: json['variant'] != null ? Map<String, dynamic>.from(json['variant']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'product': product.toJson(),
      'quantity': quantity,
      'variant': variant,
    };
  }
}
