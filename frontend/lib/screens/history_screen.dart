import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  final String accountNumber;
  const HistoryScreen({super.key, required this.accountNumber});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Payment>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _apiService.getPaymentHistory(widget.accountNumber);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Scaffold(
      appBar: AppBar(title: Text('History: ${widget.accountNumber}')),
      body: FutureBuilder<List<Payment>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No payment history found.'));
          }

          final payments = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: payments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final payment = payments[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF10B981),
                  child: Icon(Icons.check, color: Colors.white),
                ),
                title: Text(
                  currencyFormat.format(payment.amount),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(dateFormat.format(payment.paymentDate)),
                trailing: Text(
                  payment.status,
                  style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
