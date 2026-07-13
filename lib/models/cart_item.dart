import 'product.dart';

class CartItem {
  final String key;
  final String? productId;
  final Product product;
  final int quantity;
  final Map<String, dynamic>? variant;

  CartItem({
    required this.key,
    this.productId,
    required this.product,
    this.quantity = 1,
    this.variant,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      key: json['key'] ?? '',
      productId: json['productId'] ?? '',
      product: Product.fromJson(Map<String, dynamic>.from(json['product'] ?? {})),
      quantity: json['quantity'] ?? 1,
      variant: json['variant'] != null ? Map<String, dynamic>.from(json['variant']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'productId': productId,
      'product': product.toJson(),
      'quantity': quantity,
      'variant': variant,
    };
  }
}
