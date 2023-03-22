import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:miniproject/pages/login.dart';
import 'package:miniproject/service/auth_service.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController daysToGenerateController =
      TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final List<String> timeSlots = [
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
  ];

  Future<void> _addBookingSlots() async {
    DateTime start = DateTime.parse('${startDateController.text} 00:00:00');
    int days = int.parse(daysToGenerateController.text);
    DateTime end = start.add(Duration(days: days));

    while (start.isBefore(end)) {
      String formattedDate = dateFormat.format(start);

      for (String timeSlot in timeSlots) {
        await _firestore.collection('bookings').add({
          'date': formattedDate,
          'time': timeSlot,
          'bookedBy': null,
        });
      }

      start = start.add(const Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () async {
              await AuthService.logoutUser();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Start Date (yyyy-mm-dd)',
              ),
              controller: startDateController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    startDateController.text = dateFormat.format(date);
                  });
                }
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of Days',
              ),
              controller: daysToGenerateController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                _addBookingSlots();
              },
              child: const Text('Add booking slots to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
