enum BusinessType { individual, company, partnership }

enum SellerApplicationStatus { pending, underReview, approved, rejected }

class SellerApplication {
  final String userId;
  final String businessName;
  final BusinessType businessType;
  final String category;
  final String location;
  final String phone;
  final String email;
  final String mpesaNumber;
  final String description;
  final SellerApplicationStatus status;
  final String rejectionReason;

  SellerApplication({
    required this.userId,
    required this.businessName,
    this.businessType = BusinessType.individual,
    required this.category,
    required this.location,
    required this.phone,
    required this.email,
    required this.mpesaNumber,
    required this.description,
    this.status = SellerApplicationStatus.pending,
    this.rejectionReason = '',
  });

  factory SellerApplication.fromJson(Map<String, dynamic> json) {
    return SellerApplication(
      userId: json['userId'] ?? '',
      businessName: json['businessName'] ?? '',
      businessType: _businessTypeFromString(json['businessType'] as String?),
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      mpesaNumber: json['mpesaNumber'] ?? '',
      description: json['description'] ?? '',
      status: _statusFromString(json['status'] as String?),
      rejectionReason: json['rejectionReason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'businessName': businessName,
      'businessType': businessType.name,
      'category': category,
      'location': location,
      'phone': phone,
      'email': email,
      'mpesaNumber': mpesaNumber,
      'description': description,
      'status': status.name,
      'rejectionReason': rejectionReason,
    };
  }

  static BusinessType _businessTypeFromString(String? value) {
    switch (value) {
      case 'company':
        return BusinessType.company;
      case 'partnership':
        return BusinessType.partnership;
      default:
        return BusinessType.individual;
    }
  }

  static SellerApplicationStatus _statusFromString(String? value) {
    switch (value) {
      case 'under_review':
        return SellerApplicationStatus.underReview;
      case 'approved':
        return SellerApplicationStatus.approved;
      case 'rejected':
        return SellerApplicationStatus.rejected;
      default:
        return SellerApplicationStatus.pending;
    }
  }
}
