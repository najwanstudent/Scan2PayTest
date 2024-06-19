import 'package:flutter/material.dart';
import 'drawer.dart';

class editProfile extends StatelessWidget {
  const editProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      drawer: const AppDrawer(), // Add this line to include the drawer
      body: const Center(
        child: Text('Edit Profile Page'),
      ),
    );
  }
}
