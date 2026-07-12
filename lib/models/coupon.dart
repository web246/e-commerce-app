enum CouponType { percentage, fixed, freeShipping, bogo }

class Coupon {
  final String code;
  final CouponType type;
  final double value;
  final double minOrder;
  final double maxDiscount;
  final int usageLimit;
  final int usedCount;
  final DateTime? expiresAt;
  final bool isActive;

  Coupon({
    required this.code,
    this.type = CouponType.percentage,
    this.value = 0.0,
    this.minOrder = 0.0,
    this.maxDiscount = 0.0,
    this.usageLimit = 0,
    this.usedCount = 0,
    this.expiresAt,
    this.isActive = true,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'] ?? '',
      type: _typeFromString(json['type'] as String?),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      minOrder: (json['minOrder'] as num?)?.toDouble() ?? 0.0,
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble() ?? 0.0,
      usageLimit: json['usageLimit'] ?? 0,
      usedCount: json['usedCount'] ?? 0,
      expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type.name,
      'value': value,
      'minOrder': minOrder,
      'maxDiscount': maxDiscount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  static CouponType _typeFromString(String? value) {
    switch (value) {
      case 'fixed':
        return CouponType.fixed;
      case 'free_shipping':
        return CouponType.freeShipping;
      case 'bogo':
        return CouponType.bogo;
      default:
        return CouponType.percentage;
    }
  }
}
