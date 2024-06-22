import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan2pay/adminscreen/admindrawer.dart';

class AdminTestScan extends StatefulWidget {
  final num balanceToDeduct;

  const AdminTestScan({super.key, required this.balanceToDeduct});

  @override
  State<AdminTestScan> createState() => _AdminTestScanState();
}

class _AdminTestScanState extends State<AdminTestScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  num amountToDeduct = 10;
  num amountToTransfer = 0;

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

    final data = qrData;
    if (data.length != 12)
      return; // Ensure QR data has both user ID and balance

    // Fetch user document
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('ic_number', isEqualTo: data)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) return; // No user found

    DocumentReference userDoc = userSnapshot.docs.first.reference;
    num currentBalance = userSnapshot.docs.first['amount_balance'];

    // Update balance
    num newBalance = currentBalance - widget.balanceToDeduct;
    await userDoc.update({'amount_balance': newBalance});

    // Log the transaction
    await FirebaseFirestore.instance.collection('Transactions').add({
      'ic_number': data,
      'amount': widget.balanceToDeduct,
      'timestamp': FieldValue.serverTimestamp(),
    });

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
      drawer: const AppDrawerAdmin(),
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
