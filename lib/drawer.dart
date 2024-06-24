import 'package:flutter/material.dart';
import 'package:scan2pay/login.dart';

class AppDrawer extends StatelessWidget {
  final String userUid; // Add userUid to the AppDrawer

  const AppDrawer({Key? key, required this.userUid}) : super(key: key); // Modify constructor

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0), // Add padding to lower the items
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home-screen',
                  (route) => false,
                  arguments: userUid, // Pass userUid as an argument
                );
              },
            ),
            ListTile(
              title: const Text('Transaction History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/transaction-history');
              },
            ),
            ListTile(
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit-profile');
              },
            ),
            ListTile(
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/faq', arguments: userUid);
              },
            ),
            const Spacer(), // Keeps the Logout button at the bottom
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
