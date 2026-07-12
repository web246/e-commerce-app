class Review {
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String title;
  final String comment;
  final List<String> images;
  final int helpfulCount;
  final bool verifiedPurchase;
  final String status;

  Review({
    required this.productId,
    required this.userId,
    required this.userName,
    this.rating = 1,
    required this.title,
    required this.comment,
    this.images = const [],
    this.helpfulCount = 0,
    this.verifiedPurchase = false,
    this.status = 'pending',
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: json['rating'] ?? 1,
      title: json['title'] ?? '',
      comment: json['comment'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      helpfulCount: json['helpfulCount'] ?? 0,
      verifiedPurchase: json['verifiedPurchase'] ?? false,
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'title': title,
      'comment': comment,
      'images': images,
      'helpfulCount': helpfulCount,
      'verifiedPurchase': verifiedPurchase,
      'status': status,
    };
  }
}
