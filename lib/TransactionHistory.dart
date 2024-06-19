import 'package:flutter/material.dart';
import 'drawer.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      drawer: const AppDrawer(), // Add this line to include the drawer
      body: const Center(
        child: Text('Transaction History Page'),
      ),
    );
  }
}
