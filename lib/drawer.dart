import 'package:flutter/material.dart';
import 'package:scan2pay/login.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFB9A5D7)
              .withOpacity(0.9), // Purple background with opacity
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 40), // Add some space at the top
            ListTile(
              title: Text(
                'HOME',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        '/')); // Pop all routes until reaching the home screen
              },
            ),
            ListTile(
              title: Text(
                'TRANSACTION',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/transaction-history');
              },
            ),
            ListTile(
              title: Text(
                'EDIT PROFILE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit-profile');
              },
            ),
            ListTile(
              title: Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/faq');
              },
            ),
            const Spacer(),
            ListTile(
              title: Text(
                'LOGOUT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
