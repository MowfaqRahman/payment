class Customer {
  final int id;
  final String accountNumber;
  final DateTime issueDate;
  final double interestRate;
  final int tenure;
  final double emiDue;

  Customer({
    required this.id,
    required this.accountNumber,
    required this.issueDate,
    required this.interestRate,
    required this.tenure,
    required this.emiDue,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      accountNumber: json['account_number'],
      issueDate: DateTime.parse(json['issue_date']),
      interestRate: json['interest_rate'].toDouble(),
      tenure: json['tenure'],
      emiDue: json['emi_due'].toDouble(),
    );
  }
}
