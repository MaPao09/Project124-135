import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/pages/profile.dart';

import '../service/auth_service.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'ร้านตัดผม',
            style: GoogleFonts.itim(
              textStyle: const TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: 380,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 30),
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  height: 250,
                ),
                _loginHeader(),
                _loginForm(),
              ],
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
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: 400,
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
            ),
            _buildTextField(
              labelText: 'Password',
              icon: Icons.password,
              controller: _password,
              obscureText: _obscurePassword,
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
      required TextEditingController controller,
      bool obscureText = false,
      Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
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
              fontSize: 18,
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
        onPressed: () {
          // Code for handling login button press
          if (_formKey.currentState!.validate()) {
            AuthService.loginUser(_username.text + '@gmail.com', _password.text)
                .then((value) {
              if (value == 1) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ));
              } else {
                print("FAILED Login");
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
            const Size(double.maxFinite, 50),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: const Text(
          'login',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
