import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/pages/bar.dart';
import 'package:miniproject/pages/time.dart';

import 'package:miniproject/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenWidth * 0.6;
    final formWidth = screenWidth * 0.9;

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
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: formWidth,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Image.asset(
                    'assets/images/logo.png',
                    width: imageSize,
                    height: imageSize,
                  ),
                  _loginHeader(),
                  _loginForm(),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Login to My App',
          style: GoogleFonts.itim(
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
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
              obscureText: _obscurePassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter Password";
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                child: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
              ),
            ),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String labelText,
      required IconData icon,
      required FormFieldValidator<String> validator,
      required TextEditingController controller,
      bool obscureText = false,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: GoogleFonts.itim(
          textStyle: TextStyle(color: Colors.black),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
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

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final level = await AuthService.loginUser(
                _username.text + '@gmail.com', _password.text);
            if (level != null) {
              AuthService.saveLoginStatus(true);
              if (level == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddData(),
                  ),
                );
              } else if (level == 'user') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Bar(),
                  ),
                );
              }
            } else {
              print("FAILED Login");
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow),
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.black),
          ),
          fixedSize: MaterialStateProperty.all(
            const Size(double.maxFinite, 50),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          'Login',
          style: GoogleFonts.itim(
            textStyle: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
