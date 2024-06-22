import 'package:flutter/material.dart';
import 'package:scan2pay/login.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.popUntil(
                  context,
                  ModalRoute.withName(
                      '/')); // Pop all routes until reaching the home screen
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
              Navigator.pushNamed(context, '/faq');
            },
          ),
          const Spacer(),
          ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
    );
  }
}
