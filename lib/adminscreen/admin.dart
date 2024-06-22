import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scan2pay/drawer.dart';

import 'admindrawer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int amountToTransfer = 0;

  Future<void> _transferMoney() async {
    // Replace with your actual Firestore path and document ID
    String userId = "QSMVojIge9Z0QUfrIwg9"; // Replace with the actual user ID

    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    DocumentSnapshot userSnapshot = await userDoc.get();
    int currentBalance = userSnapshot['amount_balance'];

    // Update balance
    int newBalance = currentBalance + amountToTransfer;
    await userDoc.update({'amount_balance': newBalance});

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Transferred: \$$amountToTransfer. New Balance: \$$newBalance')),
    );

    setState(() {
      amountToTransfer = 0; // Reset the transfer amount
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      drawer: const AppDrawerAdmin(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration:
                  const InputDecoration(labelText: 'Amount to Transfer'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amountToTransfer = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _transferMoney,
              child: const Text('Transfer Money'),
            ),
          ),
        ],
      ),
    );
  }
}
