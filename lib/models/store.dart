class Store {
  final String name;
  final String slug;
  final String description;
  final String logoUrl;
  final String bannerUrl;
  final String ownerId;
  final String status;
  final String category;
  final String location;
  final String phone;
  final String email;
  final bool verified;
  final int followersCount;
  final int productsCount;
  final double rating;
  final double commissionRate;

  Store({
    required this.name,
    required this.slug,
    required this.description,
    required this.logoUrl,
    required this.bannerUrl,
    required this.ownerId,
    required this.status,
    required this.category,
    required this.location,
    required this.phone,
    required this.email,
    this.verified = false,
    this.followersCount = 0,
    this.productsCount = 0,
    this.rating = 0.0,
    this.commissionRate = 0.0,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      ownerId: json['ownerId'] ?? '',
      status: json['status'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      verified: json['verified'] ?? false,
      followersCount: json['followersCount'] ?? 0,
      productsCount: json['productsCount'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'description': description,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'ownerId': ownerId,
      'status': status,
      'category': category,
      'location': location,
      'phone': phone,
      'email': email,
      'verified': verified,
      'followersCount': followersCount,
      'productsCount': productsCount,
      'rating': rating,
      'commissionRate': commissionRate,
    };
  }
}
