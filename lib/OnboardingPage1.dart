import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'onboardingpage2.dart';
import 'login.dart';

class OnboardingPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.0, right: 16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Skip'),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/onboarding1.png', // Add your image path here
                      fit: BoxFit
                          .cover, // Ensure the image covers the entire space
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Help Government As a Whole',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Supports government efforts to guarantee financial assistance for all. Boosts transparency and accountability.',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 13.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
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
                    currentItem: 0,
                    count: 2,
                    unselectedColor: Colors.grey,
                    selectedColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 16.0),
                SizedBox(
                  width: 100.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnboardingPage2()),
                      );
                    },
                    child: Text('Next'),
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
