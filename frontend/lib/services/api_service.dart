import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import '../models/payment.dart';

class ApiService {
  // Use environment variable or default for local dev
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000',
  );

  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Customer.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Payment> makePayment(String accountNumber, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'account_number': accountNumber,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to make payment: ${response.body}');
    }
  }

  Future<List<Payment>> getPaymentHistory(String accountNumber) async {
    final response = await http.get(Uri.parse('$baseUrl/payments/$accountNumber'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Payment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load payment history');
    }
  }
}
