import 'package:flutter/material.dart';
import 'onboardingpage1.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to OnboardingPage1 after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPage1()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.jpg',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Bringing government support to your fingertips',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700, // Use bold weight
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
