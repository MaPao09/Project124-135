import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:miniproject/pages/login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("success"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            Center(
              child: Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
            Text("Success")
          ],
        ),
      ),
    );
  }
}
