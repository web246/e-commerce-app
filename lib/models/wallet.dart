class Wallet {
  final String userId;
  final double balance;
  final String currency;
  final List<Map<String, dynamic>> transactions;

  Wallet({
    required this.userId,
    this.balance = 0.0,
    this.currency = 'KES',
    this.transactions = const [],
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      userId: json['userId'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'KES',
      transactions: List<Map<String, dynamic>>.from(json['transactions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'balance': balance,
      'currency': currency,
      'transactions': transactions,
    };
  }
}
