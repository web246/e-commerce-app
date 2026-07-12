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
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      productPrice: (json['productPrice'] as num?)?.toDouble() ?? 0.0,
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
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
