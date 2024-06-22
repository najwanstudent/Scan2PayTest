import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  num balance = 0;
  String qrData = "";
  String icNumber = "";

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    // Replace with your actual Firestore path and document ID
    String userId = "s1b7GDpJbC2hNkdCbsFB"; // Replace with the actual user ID

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    setState(() {
      balance = userDoc['amount_balance'];
      qrData = userDoc['qr']; // Assuming the QR data includes the user QR code
      icNumber = userDoc['ic_number'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan2Pay'),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Current Balance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$$balance',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: '$icNumber', // Include balance in the QR data
              size: 200.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _printQr(context),
              child: const Text('PRINT QR'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                  context, '/admin'), // Navigate to AdminScreen
              child: const Text('SCAN QR'),
            ),
          ],
        ),
      ),
    );
  }

  void _printQr(BuildContext context) {
    // Implement print functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print functionality is not implemented')),
    );
  }
}
