import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scan2pay/homescreen.dart'; // Import the HomeScreen class

import 'TransactionHistory.dart';
import 'admin.dart';
import 'editProfile.dart';
import 'faq.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Scan2PayApp());
}

class Scan2PayApp extends StatelessWidget {
  const Scan2PayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan2Pay',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/home-screen': (context) => const HomeScreen(
              userUid: '',
            ),
        '/transaction-history': (context) => const TransactionHistory(),
        '/edit-profile': (context) => const editProfile(),
        '/faq': (context) => const FAQ(),
        '/admin': (context) => const AdminScreen(),
      },
    );
  }
}
