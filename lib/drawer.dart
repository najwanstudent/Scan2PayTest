import 'package:flutter/material.dart';
import 'package:scan2pay/login.dart';
import 'UserUidSingleton.dart'; // Import the UserUidSingleton class

class AppDrawer extends StatelessWidget {
  final String userUid; // User UID to identify the user

  const AppDrawer({Key? key, required this.userUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? userName = UserUidSingleton().userUid; // Get the username from the singleton

    return Drawer(
      child: Container(
        color: Colors.white, // Change background color to white
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                userName ?? 'User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.grey,
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            buildDrawerItem(context, 'Home', '/home-screen', Icons.home),
            buildDrawerItem(context, 'Transaction History', '/transaction-history', Icons.history),
            buildDrawerItem(context, 'Edit Profile', '/edit-profile', Icons.edit),
            buildDrawerItem(context, 'FAQ', '/faq', Icons.help),
            const Divider(), // Divider for visual separation
            buildDrawerLogout(context, 'Logout', '/login', Icons.logout),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, String route, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (route == '/login') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            (route) => false,
            arguments: userUid, // Pass userUid as an argument if needed
          );
        }
      },
    );
  }

  Widget buildDrawerLogout(BuildContext context, String title, String route, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.red, // Logout text color
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
    );
  }
}
