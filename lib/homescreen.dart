import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  final String userUid;

  const HomeScreen({Key? key, required this.userUid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  num balance = 0;
  String icNumber = "";

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userUid)
        .get();

    setState(() {
      balance = userDoc['amount_balance'];
      icNumber = userDoc['ic_number'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan2Pay'),
      ),
      drawer: AppDrawer(),
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
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _printQr(context),
              child: const Text('PRINT QR'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _printQr(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                // pw.Text('Current Balance: \$${balance.toString()}'),
                pw.SizedBox(height: 20),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: icNumber,
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save the PDF to the device
    final output =
        await getTemporaryDirectory(); // Use getTemporaryDirectory() for testing purposes
    final file = File('${output.path}/qr_code.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR code saved to ${file.path}'),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            OpenFile.open(file.path);
          },
        ),
      ),
    );
  }
}
