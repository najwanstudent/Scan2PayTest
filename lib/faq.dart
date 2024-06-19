import 'package:flutter/material.dart';
import 'drawer.dart';

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      drawer: const AppDrawer(), // Add this line to include the drawer
      body: const Center(
        child: Text('FAQ Page'),
      ),
    );
  }
}
