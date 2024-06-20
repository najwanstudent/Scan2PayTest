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
  int balanceToDeduct = 0;
  int amountToTransfer = 0;

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
    if (data.length != 2) return; // Ensure QR data has both user ID and balance

    final userQr = data[0];
    final balanceToDeduct = int.tryParse(data[1]) ?? 0;

    // Fetch user document
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('qr', isEqualTo: userQr)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) return; // No user found

    DocumentReference userDoc = userSnapshot.docs.first.reference;
    int currentBalance = userSnapshot.docs.first['amount_balance'];

    // Update balance
    int newBalance = currentBalance - balanceToDeduct;
    await userDoc.update({'amount_balance': newBalance});

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Balance updated: \$$newBalance')),
    );

    // Navigate back to home screen
    Navigator.pop(context);
  }

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Amount to Deduct'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  balanceToDeduct = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _processQrData(result?.code),
              child: const Text('Deduct Amount'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
