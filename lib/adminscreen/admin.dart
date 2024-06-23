import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admindrawer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int amountToTransfer = 0;
  bool isLoading = false;

  Future<void> _transferMoney() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    final int transferAmount = amountToTransfer; // Store the amount to transfer

    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var userDoc in userSnapshot.docs) {
      num currentBalance = userDoc['amount_balance'];
      num newBalance = currentBalance + transferAmount;
      batch.update(userDoc.reference, {'amount_balance': newBalance});
    }

    await batch.commit();

    setState(() {
      isLoading = false; // Hide loading indicator
      amountToTransfer = 0; // Reset the transfer amount
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transferred \$$transferAmount to all users')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      drawer: const AppDrawerAdmin(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isLoading ? null : _transferMoney,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text('Transfer Money'),
            ),
          ),
        ],
      ),
    );
  }
}
