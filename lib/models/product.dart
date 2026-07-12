enum ProductStatus { active, inactive, outOfStock, pendingReview }

enum ProductCondition { newCondition, used, refurbished }

class Product {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String storeId;
  final String storeName;
  final String category;
  final String subcategory;
  final String brand;
  final double price;
  final double? oldPrice;
  final int discountPercent;
  final String currency;
  final List<String> images;
  final String thumbnail;
  final int stock;
  final String sku;
  final double rating;
  final int reviewsCount;
  final int soldCount;
  final ProductStatus status;
  final bool isFeatured;
  final bool isFlashSale;
  final DateTime? flashSaleEnd;
  final int flashSaleStock;
  final bool freeShipping;
  final double shippingFee;
  final List<String> tags;
  final Map<String, dynamic> specifications;
  final List<dynamic> variants;
  final double weight;
  final String dimensions;
  final bool isNewArrival;
  final bool isBestSeller;
  final ProductCondition condition;

  Product({
    this.id = '',
    required this.name,
    required this.slug,
    required this.description,
    required this.storeId,
    required this.storeName,
    required this.category,
    required this.subcategory,
    required this.brand,
    required this.price,
    this.oldPrice,
    this.discountPercent = 0,
    this.currency = 'KES',
    required this.images,
    required this.thumbnail,
    this.stock = 0,
    required this.sku,
    this.rating = 0,
    this.reviewsCount = 0,
    this.soldCount = 0,
    this.status = ProductStatus.active,
    this.isFeatured = false,
    this.isFlashSale = false,
    this.flashSaleEnd,
    this.flashSaleStock = 0,
    this.freeShipping = false,
    this.shippingFee = 0,
    this.tags = const [],
    this.specifications = const {},
    this.variants = const [],
    this.weight = 0,
    this.dimensions = '',
    this.isNewArrival = false,
    this.isBestSeller = false,
    this.condition = ProductCondition.newCondition,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      discountPercent: json['discountPercent'] ?? 0,
      currency: json['currency'] ?? 'KES',
      images: List<String>.from(json['images'] ?? []),
      thumbnail: json['thumbnail'] ?? '',
      stock: json['stock'] ?? 0,
      sku: json['sku'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      soldCount: json['soldCount'] ?? 0,
      status: _statusFromString(json['status'] as String?),
      isFeatured: json['isFeatured'] ?? false,
      isFlashSale: json['isFlashSale'] ?? false,
      flashSaleEnd: json['flashSaleEnd'] != null ? DateTime.tryParse(json['flashSaleEnd']) : null,
      flashSaleStock: json['flashSaleStock'] ?? 0,
      freeShipping: json['freeShipping'] ?? false,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      tags: List<String>.from(json['tags'] ?? []),
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      variants: List<dynamic>.from(json['variants'] ?? []),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      dimensions: json['dimensions'] ?? '',
      isNewArrival: json['isNewArrival'] ?? false,
      isBestSeller: json['isBestSeller'] ?? false,
      condition: _conditionFromString(json['condition'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'storeId': storeId,
      'storeName': storeName,
      'category': category,
      'subcategory': subcategory,
      'brand': brand,
      'price': price,
      'oldPrice': oldPrice,
      'discountPercent': discountPercent,
      'currency': currency,
      'images': images,
      'thumbnail': thumbnail,
      'stock': stock,
      'sku': sku,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'soldCount': soldCount,
      'status': status.name,
      'isFeatured': isFeatured,
      'isFlashSale': isFlashSale,
      'flashSaleEnd': flashSaleEnd?.toIso8601String(),
      'flashSaleStock': flashSaleStock,
      'freeShipping': freeShipping,
      'shippingFee': shippingFee,
      'tags': tags,
      'specifications': specifications,
      'variants': variants,
      'weight': weight,
      'dimensions': dimensions,
      'isNewArrival': isNewArrival,
      'isBestSeller': isBestSeller,
      'condition': condition.name,
    };
  }

  static ProductStatus _statusFromString(String? value) {
    switch (value) {
      case 'inactive':
        return ProductStatus.inactive;
      case 'out_of_stock':
        return ProductStatus.outOfStock;
      case 'pending_review':
        return ProductStatus.pendingReview;
      default:
        return ProductStatus.active;
    }
  }

  static ProductCondition _conditionFromString(String? value) {
    switch (value) {
      case 'used':
        return ProductCondition.used;
      case 'refurbished':
        return ProductCondition.refurbished;
      default:
        return ProductCondition.newCondition;
    }
  }
}
