enum OrderStatus { pending, confirmed, packed, shipped, outForDelivery, delivered, cancelled, refunded }

enum PaymentMethod { mpesa, stripe, paypal, flutterwave, wallet, cashOnDelivery, card }

enum PaymentStatus { pending, paid, failed, refunded }

enum DeliveryMethod { bodaExpress, standard, pickup }

class Order {
  final String orderNumber;
  final String buyerId;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final List<dynamic> items;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double discount;
  final double total;
  final String currency;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final String paymentReference;
  final Map<String, dynamic> shippingAddress;
  final DeliveryMethod deliveryMethod;
  final DateTime? estimatedDelivery;
  final String trackingNumber;
  final String carrier;
  final String couponCode;
  final String storeId;
  final String storeName;
  final List<Map<String, dynamic>> timeline;

  Order({
    required this.orderNumber,
    required this.buyerId,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    this.items = const [],
    this.subtotal = 0.0,
    this.shippingFee = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    this.total = 0.0,
    this.currency = 'KES',
    this.status = OrderStatus.pending,
    this.paymentMethod = PaymentMethod.mpesa,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentReference = '',
    this.shippingAddress = const {},
    this.deliveryMethod = DeliveryMethod.standard,
    this.estimatedDelivery,
    this.trackingNumber = '',
    this.carrier = '',
    this.couponCode = '',
    this.storeId = '',
    this.storeName = '',
    this.timeline = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json['orderNumber'] ?? '',
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerEmail: json['buyerEmail'] ?? '',
      buyerPhone: json['buyerPhone'] ?? '',
      items: List<dynamic>.from(json['items'] ?? []),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'KES',
      status: _statusFromString(json['status'] as String?),
      paymentMethod: _paymentMethodFromString(json['paymentMethod'] as String?),
      paymentStatus: _paymentStatusFromString(json['paymentStatus'] as String?),
      paymentReference: json['paymentReference'] ?? '',
      shippingAddress: Map<String, dynamic>.from(json['shippingAddress'] ?? {}),
      deliveryMethod: _deliveryMethodFromString(json['deliveryMethod'] as String?),
      estimatedDelivery: json['estimatedDelivery'] != null ? DateTime.tryParse(json['estimatedDelivery']) : null,
      trackingNumber: json['trackingNumber'] ?? '',
      carrier: json['carrier'] ?? '',
      couponCode: json['couponCode'] ?? '',
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      timeline: List<Map<String, dynamic>>.from(json['timeline'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerPhone': buyerPhone,
      'items': items,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'tax': tax,
      'discount': discount,
      'total': total,
      'currency': currency,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'paymentReference': paymentReference,
      'shippingAddress': shippingAddress,
      'deliveryMethod': deliveryMethod.name,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'carrier': carrier,
      'couponCode': couponCode,
      'storeId': storeId,
      'storeName': storeName,
      'timeline': timeline,
    };
  }

  static OrderStatus _statusFromString(String? value) {
    switch (value) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'packed':
        return OrderStatus.packed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'refunded':
        return OrderStatus.refunded;
      default:
        return OrderStatus.pending;
    }
  }

  static PaymentMethod _paymentMethodFromString(String? value) {
    switch (value) {
      case 'stripe':
        return PaymentMethod.stripe;
      case 'paypal':
        return PaymentMethod.paypal;
      case 'flutterwave':
        return PaymentMethod.flutterwave;
      case 'wallet':
        return PaymentMethod.wallet;
      case 'cash_on_delivery':
        return PaymentMethod.cashOnDelivery;
      case 'card':
        return PaymentMethod.card;
      default:
        return PaymentMethod.mpesa;
    }
  }

  static PaymentStatus _paymentStatusFromString(String? value) {
    switch (value) {
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  static DeliveryMethod _deliveryMethodFromString(String? value) {
    switch (value) {
      case 'boda_express':
        return DeliveryMethod.bodaExpress;
      case 'pickup':
        return DeliveryMethod.pickup;
      default:
        return DeliveryMethod.standard;
    }
  }
}
