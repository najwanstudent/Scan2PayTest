import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Transactions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final userId = transaction['user_id'];
              final amount = transaction['amount'];
              final timestamp =
                  (transaction['timestamp'] as Timestamp).toDate();

              return ListTile(
                title: Text('User ID: $userId'),
                subtitle: Text('Amount: \$$amount\nDate: $timestamp'),
              );
            },
          );
        },
      ),
    );
  }
}
