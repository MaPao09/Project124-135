import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miniproject/pages/bar.dart';
import 'package:miniproject/pages/home.dart';
import 'package:miniproject/pages/time.dart';
import 'package:miniproject/service/auth_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 1));
    bool isLoggedIn = await AuthService.getLoginStatus();
    String? userRole;
    if (isLoggedIn) {
      userRole = await AuthService.getUserLevel();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (isLoggedIn) {
            if (userRole == 'admin') {
              return AddData();
            } else {
              return Bar();
            }
          } else {
            return HomePage();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 203, 47),
      body: Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}
