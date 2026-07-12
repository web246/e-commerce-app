class Category {
  final String name;
  final String slug;
  final String icon;
  final String color;
  final int sortOrder;
  final bool isActive;

  Category({
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'icon': icon,
      'color': color,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }
}
