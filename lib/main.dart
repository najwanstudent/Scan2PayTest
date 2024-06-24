import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scan2pay/OnBoardingPage1.dart';
import 'package:scan2pay/adminscreen/inputamount.dart';
import 'package:scan2pay/homescreen.dart'; // Import the HomeScreen class

import 'OnboardingPage2.dart';
import 'TransactionHistory.dart';
import 'adminscreen/admin.dart';
import 'editProfile.dart';
import 'faq.dart';
import 'firebase_options.dart';
import 'landing_page.dart';
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
        '/': (context) => LandingPage(),
        '/onboarding1': (context) => OnboardingPage1(),
        '/onboarding2': (context) => OnboardingPage2(),
        '/login-page': (context) => const LoginPage(), // Route to LoginPage
        '/home-screen': (context) => HomeScreen(
              userUid: ModalRoute.of(context)!.settings.arguments as String,
            ), // Route to HomeScreen
        '/transaction-history': (context) => TransactionHistoryScreen(),
        '/edit-profile': (context) => const EditProfile(),
        '/faq': (context) => const FAQ(),
        '/admin': (context) =>
            const AdminScreen(), // Add route for admin screen
        '/admin-test-scan': (context) =>
            AmountInputScreen(), // Add route for admin screen
      },
    );
  }
}
