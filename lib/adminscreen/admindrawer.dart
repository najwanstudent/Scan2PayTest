import 'package:flutter/material.dart';

class AppDrawerAdmin extends StatelessWidget {
  const AppDrawerAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Admin Transfer Money'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin');
            },
          ),
          ListTile(
            title: const Text('Test Scan Merchant'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin-test-scan');
            },
          ),
        ],
      ),
    );
  }
}
