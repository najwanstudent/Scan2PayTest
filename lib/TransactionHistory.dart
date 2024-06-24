import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'UserUidSingleton.dart'; // Import the UserUidSingleton class
import 'drawer.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.purple[300], // Light purple app bar background
      ),
      drawer: AppDrawer(userUid: UserUidSingleton().userUid),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Transactions')
            .where("ic_number", isEqualTo: UserUidSingleton().userUid)
            .orderBy('timestamp', descending: true) // Make sure to order by timestamp
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

              // Access the document data as a Map<String, dynamic>
              final Map<String, dynamic> data = transaction.data() as Map<String, dynamic>;

              // Extract fields from the data map
              final amount = data['amount'];
              final timestamp = (data['timestamp'] as Timestamp).toDate();
              final formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm').format(timestamp); // Format the timestamp

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Colors.grey[200], // Light grey card background
                child: ListTile(
                  title: Text(
                    'Transaction ID: ${transaction.id}',
                    style: TextStyle(fontSize: 14, color: Colors.purple[800]), // Purple text color
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount: \$$amount',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple), // Purple amount color
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Date/Time: $formattedTimestamp',
                        style: TextStyle(color: Colors.grey[600]), // Grey timestamp color
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
