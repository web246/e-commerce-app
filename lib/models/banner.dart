class BannerModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String ctaText;
  final String ctaUrl;
  final String badgeText;
  final int sortOrder;
  final String type;
  final String gradientFrom;
  final String gradientTo;

  BannerModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.ctaText,
    required this.ctaUrl,
    this.badgeText = '',
    this.sortOrder = 0,
    this.type = 'hero',
    this.gradientFrom = '',
    this.gradientTo = '',
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ctaText: json['ctaText'] ?? '',
      ctaUrl: json['ctaUrl'] ?? '',
      badgeText: json['badgeText'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      type: json['type'] ?? 'hero',
      gradientFrom: json['gradientFrom'] ?? '',
      gradientTo: json['gradientTo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'ctaText': ctaText,
      'ctaUrl': ctaUrl,
      'badgeText': badgeText,
      'sortOrder': sortOrder,
      'type': type,
      'gradientFrom': gradientFrom,
      'gradientTo': gradientTo,
    };
  }
}
