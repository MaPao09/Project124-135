import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/pages/login.dart';
import 'package:miniproject/service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('users'); // Add CollectionReference
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Sprite Barber',
            style: GoogleFonts.itim(
              textStyle: const TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: screenWidth * 0.9,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                  ),
                ),
                _registerHeader(),
                _registerForm(screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Register to My App',
          style: GoogleFonts.itim(
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _registerForm(double screenHeight) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                labelText: 'Full Name',
                icon: Icons.person,
                controller: _name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Name";
                  }
                  return null;
                },
              ),
              _buildTextField(
                labelText: 'Email',
                icon: Icons.email,
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Email";
                  }
                  final pattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                  if (!pattern.hasMatch(value)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              _buildTextField(
                labelText: 'Username',
                icon: Icons.person_outline,
                controller: _username,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Username";
                  }
                  return null;
                },
              ),
              _buildTextField(
                labelText: 'Password',
                icon: Icons.password,
                controller: _password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Password";
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              _registerButton(screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String labelText,
      required IconData icon,
      required TextEditingController controller,
      required FormFieldValidator validator,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: GoogleFonts.itim(
          textStyle: TextStyle(color: Colors.black),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black), // Set border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.black), // Set focused border color
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.itim(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 13,
            ),
          ),
          prefixIcon: Icon(icon, color: Colors.black),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _registerButton(double screenHeight) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
      child: ElevatedButton(
        onPressed: () {
// Code for handling register button press
          if (_formKey.currentState!.validate()) {
            AuthService.registerUser(
                    _username.text + '@gmail.com', _password.text)
                .then((value) {
              if (value == 1) {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                users.doc(uid).set({
                  "name": _name.text,
                  "email": _email.text,
                  "username": _username.text,
                  "password": _password.text,
                  "level": 'user',
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              } else {
                print("FAILED Register");
              }
            });
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow),
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.black),
          ),
          fixedSize: MaterialStateProperty.all(
            Size(double.maxFinite, screenHeight * 0.07),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          'Register',
          style: GoogleFonts.itim(
            textStyle: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
