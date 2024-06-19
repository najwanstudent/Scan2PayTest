import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scan2pay/homescreen.dart';
import 'package:scan2pay/signup.dart'; // Import the SignUpPage

import 'admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _icNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String icNumber = _icNumberController.text.trim();
    final String password = _passwordController.text.trim();

    if (icNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both IC number and password')),
      );
      return;
    }

    // Check if the user is in the 'Users' collection
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('ic_number', isEqualTo: icNumber)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      // User found, navigate to main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }

    // Check if the user is in the 'Admin' collection
    QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
        .collection('Admin')
        .where('ic_number', isEqualTo: icNumber)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (adminSnapshot.docs.isNotEmpty) {
      // Admin found, navigate to admin screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
      return;
    }

    // No matching user or admin found
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid IC number or password')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _icNumberController,
              decoration: const InputDecoration(labelText: 'IC Number'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SignUpPage()), // Navigate to SignUpPage
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
