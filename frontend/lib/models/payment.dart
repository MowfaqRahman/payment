class Payment {
  final int id;
  final int customerId;
  final DateTime paymentDate;
  final double amount;
  final String status;

  Payment({
    required this.id,
    required this.customerId,
    required this.paymentDate,
    required this.amount,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      customerId: json['customer_id'],
      paymentDate: DateTime.parse(json['payment_date']),
      amount: json['amount'].toDouble(),
      status: json['status'],
    );
  }
}
