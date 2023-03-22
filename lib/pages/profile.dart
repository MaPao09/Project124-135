import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miniproject/pages/home.dart';

import 'package:intl/intl.dart';
import 'package:miniproject/service/auth_service.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _ProfileState extends State<Profile> {
  Widget build(BuildContext context) {
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
          actions: [
            // Add the actions list to the AppBar
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                await AuthService.logoutUser(); // Logout the user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: SizedBox(
            width: 380,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: [_buildProfile()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<DocumentSnapshot>(
        stream: _getUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  radius: 100,
                ),
                SizedBox(height: 30),
                Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        _buildProfileField('ชื่อผู้ใช้งาน', 'name', userData)),

                // Add more personal data fields here
                SizedBox(height: 10),
                _buildUserBookings(),
              ],
            );
          } else {
            return Container(); // Replace CircularProgressIndicator with an empty Container
          }
        },
      ),
    );
  }

  Stream<DocumentSnapshot> _getUserData() async* {
    final user = _auth.currentUser;
    yield* _firestore.collection('users').doc(user!.uid).snapshots();
  }
}

Widget _buildProfileField(
    String label, String key, Map<String, dynamic> userData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label: ${userData[key]}',
        style: GoogleFonts.itim(
          textStyle: TextStyle(fontSize: 20),
        ),
      ),
      SizedBox(height: 8),
    ],
  );
}

Widget _buildUserBookings() {
  final user = _auth.currentUser;
  return StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('bookings')
        .where('bookedBy', isEqualTo: user!.uid)
        .snapshots(),
    builder:
        (BuildContext context, AsyncSnapshot<QuerySnapshot> bookingSnapshot) {
      if (bookingSnapshot.hasData) {
        final bookings = bookingSnapshot.data!.docs;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith((states) =>
                    Colors.white), // Set heading row background color to white
                columnSpacing: 16,
                columns: [
                  DataColumn(
                      label: Text(
                    'วันที่จอง',
                    style: GoogleFonts.itim(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'เวลา',
                    style: GoogleFonts.itim(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'ทรงผมที่เลือก',
                    style: GoogleFonts.itim(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'ราคา',
                    style: GoogleFonts.itim(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),
                ],
                rows: bookings.map((bookingDoc) {
                  final booking = bookingDoc.data() as Map<String, dynamic>;
                  DateTime bookingDate = DateTime.parse(booking['date']);
                  return DataRow(
                    color: MaterialStateColor.resolveWith((states) =>
                        Colors.white), // Set data row background color to white
                    cells: [
                      DataCell(Text(
                        DateFormat.yMMMd().format(bookingDate),
                        style: GoogleFonts.itim(
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                      )),
                      DataCell(Text(
                        booking['time'],
                        style: GoogleFonts.itim(
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                      )),
                      DataCell(Text(
                        booking['hairstyle'],
                        style: GoogleFonts.itim(
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                      )),
                      DataCell(Text(
                        '${booking['price']} บาท',
                        style: GoogleFonts.itim(
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    },
  );
}
