class WishlistItem {
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final String storeId;
  final String storeName;

  WishlistItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.storeId,
    required this.storeName,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['productId'] ?? json['product_id'] ?? '',
      productName: json['productName'] ?? json['product_name'] ?? '',
      productImage: json['productImage'] ?? json['product_image'] ?? '',
      productPrice: (json['productPrice'] ?? json['product_price'] as num?)?.toDouble() ?? 0.0,
      storeId: json['storeId'] ?? json['store_id'] ?? '',
      storeName: json['storeName'] ?? json['store_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'storeId': storeId,
      'storeName': storeName,
    };
  }
}
