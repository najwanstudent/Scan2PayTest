import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final int balanceToDeduct = 100; // Set the amount to deduct automatically

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        _processQrData(result!.code);
        controller.stopCamera(); // Stop the camera after scanning
      }
    });
  }

  Future<void> _processQrData(String? qrData) async {
    if (qrData == null) return;

    final data = qrData.split('|');
    if (data.length != 2) {
      print('Invalid QR data format');
      return; // Ensure QR data has both user ID and balance
    }

    final userId = data[0];
    final userBalance = int.tryParse(data[1]) ?? 0;

    print('QR Data: userId = $userId, userBalance = $userBalance');

    // Fetch user document
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (!userDoc.exists) {
      print('No user found with ID: $userId');
      return; // No user found
    }

    int currentBalance = userDoc['amount_balance'];
    print('Current balance: $currentBalance');

    // Update balance
    int newBalance = currentBalance - balanceToDeduct;
    if (newBalance < 0) newBalance = 0; // Ensure balance doesn't go negative
    await userDoc.reference.update({'amount_balance': newBalance});

    print('New balance: $newBalance');

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Balance updated: \$$newBalance')),
    );

    // Navigate back to home screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${result!.format}   Data: ${result!.code}')
                  : const Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }
}
