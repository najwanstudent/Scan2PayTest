import 'package:flutter/material.dart';
import 'package:scan2pay/adminscreen/admindrawer.dart';
import 'package:scan2pay/adminscreen/admintestscan.dart';

class AmountInputScreen extends StatefulWidget {
  @override
  _AmountInputScreenState createState() => _AmountInputScreenState();
}

class _AmountInputScreenState extends State<AmountInputScreen> {
  TextEditingController balanceController = TextEditingController();

  @override
  void dispose() {
    balanceController.dispose();
    super.dispose();
  }

  void _navigateToQRScreen() {
    final balanceToDeduct = num.tryParse(balanceController.text) ?? 0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminTestScan(balanceToDeduct: balanceToDeduct),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Amount to Deduct')),
      drawer: const AppDrawerAdmin(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter amount to deduct',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToQRScreen,
              child: Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
