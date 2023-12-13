import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/screens/login/login_screen.dart';
import 'package:social_app/screens/main_screen.dart';

import 'details_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  //UserAuth userAuth = UserAuth();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _controller.repeat(); // Repeat the rotation animation
    splashTimer();
  }

  void splashTimer() {
    Timer(Duration(seconds: 3), () async {
      _controller.stop(); // Stop the rotation after 3 seconds
      bool check = FirebaseAuth.instance.currentUser != null;

      SharedPreferences prefs = await SharedPreferences
          .getInstance(); // getting bool value false to stop the user on Details Screen
      bool detailsAdded = prefs.getBool('detailsAdded') ?? false;

      if (check) {
        //bool to check either is user is null or not
        if (detailsAdded) {
          //bool to check either user entered details or not
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(
                comingFromProfile: false,
              ),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Image.asset(
                      'assets/images/img.png',
                      width: 100,
                      height: 100,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Welcome to your Social App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
