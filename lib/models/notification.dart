enum NotificationType { order, payment, promotion, system, seller, review }

class AppNotification {
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final String actionUrl;

  AppNotification({
    required this.userId,
    required this.title,
    required this.message,
    this.type = NotificationType.system,
    this.isRead = false,
    this.actionUrl = '',
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: _typeFromString(json['type'] as String?),
      isRead: json['isRead'] ?? false,
      actionUrl: json['actionUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'isRead': isRead,
      'actionUrl': actionUrl,
    };
  }

  static NotificationType _typeFromString(String? value) {
    switch (value) {
      case 'order':
        return NotificationType.order;
      case 'payment':
        return NotificationType.payment;
      case 'promotion':
        return NotificationType.promotion;
      case 'seller':
        return NotificationType.seller;
      case 'review':
        return NotificationType.review;
      default:
        return NotificationType.system;
    }
  }
}
