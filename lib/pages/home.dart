import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/pages/login.dart';
import 'package:miniproject/pages/register.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beautiful App Bar Example',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 203, 47),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // remove app bar shadow
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
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Image.asset(
                    'assets/images/logo.png', // Replace this with the path to your logo file
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50, // increase the height of the container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Welcome to My App',
                      style: GoogleFonts.itim(
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Code for handling login button press

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.black),
                          ),
                          fixedSize: MaterialStateProperty.all(
                            const Size(370, 50),
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
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Code for handling login button press
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.black),
                          ),
                          fixedSize: MaterialStateProperty.all(
                            const Size(370, 50),
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
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
