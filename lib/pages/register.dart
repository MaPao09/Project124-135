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
  bool _obscurePassword = true;
  CollectionReference users =
      FirebaseFirestore.instance.collection('users'); // Add CollectionReference
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register Page',
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
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  height: 250,
                ),
                _registerHeader(),
                _registerForm(),
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
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _registerForm() {
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
              labelText: 'Full Name',
              icon: Icons.person,
              controller: _name,
            ),
            _buildTextField(
              labelText: 'Email',
              icon: Icons.email,
              controller: _email,
            ),
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
            _registerButton(),
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

  Widget _registerButton() {
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
            const Size(double.maxFinite, 50),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: const Text(
          'register',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
