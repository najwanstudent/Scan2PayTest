import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'login.dart';

class OnboardingPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/onboarding2.png',
                      fit: BoxFit
                          .cover, // Ensure the image covers the entire space
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Offline Access',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'We offer payment with no internet connections.',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: PageViewDotIndicator(
                    currentItem: 1,
                    count: 2,
                    unselectedColor: Colors.grey,
                    selectedColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 16.0),
                SizedBox(
                  width: 100.0, // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Get Started!'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
