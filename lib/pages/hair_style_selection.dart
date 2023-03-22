import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproject/pages/bar.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _selectedHairStyle;
  String? _selectedHairStylePrice;
  DateTime _selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _selectedHairStyleImageURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 203, 47),
      appBar: buildAppBar(),
      body: Stack(
        children: [
          _selectedHairStyle == null
              ? _buildSelectHairStyle()
              : _buildBookingScreen(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: _selectedHairStyle != null
          ? Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedHairStyle = null;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                  'Sprite Barber',
                  style: GoogleFonts.itim(
                    textStyle:
                        const TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
              ],
            )
          : Text(
              'Sprite Barber',
              style: GoogleFonts.itim(
                textStyle: const TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
      actions: [],
    );
  }

  Widget _buildSelectHairStyle() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('hairstyles').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final List<DocumentSnapshot> hairstyles = snapshot.data!.docs;
        return ListView.separated(
          itemCount: hairstyles.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 16.0, color: Colors.grey);
          },
          itemBuilder: (BuildContext context, int index) {
            final hairstyleData =
                hairstyles[index].data() as Map<String, dynamic>;
            final String name = hairstyleData['name'];
            final String price = hairstyleData['price'];
            final String description = hairstyleData['description'];
            final String imageURL = hairstyleData['imageURL'];

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedHairStyle = name;
                  _selectedHairStyleImageURL = imageURL;
                  _selectedHairStylePrice = price;
                });
              },
              child: Card(
                margin: EdgeInsets.all(10.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        image: imageURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                child: Text(
                                  'ราคา ' + price + ' บาท',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(description),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _showConfirmationDialog(
      String title, String content, VoidCallback onPressed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: onPressed,
            ),
          ],
        );
      },
    );
  }

  _bookSlot(DocumentReference bookingRef, String currentUid) async {
    bookingRef.update({
      'bookedBy': currentUid,
      'hairstyle': _selectedHairStyle,
      'price': _selectedHairStylePrice,
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Bar(),
      ),
    );
  }

  _cancelBooking(DocumentReference bookingRef) async {
    bookingRef.update({
      'bookedBy': FieldValue.delete(),
      'hairstyle': FieldValue.delete(),
      'price': FieldValue.delete(),
    });
    Navigator.of(context).pop();
  }

  Widget _buildBookingScreen() {
    return ListView(
      children: [
        Column(
          children: [
            _buildSelectedHairStyleImage(),
            _buildDateSelector(context),
            _buildBookingCalendar(),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedHairStyleImage() {
    return _selectedHairStyleImageURL != null
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: _selectedHairStyleImageURL!,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedHairStyle.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Text(
                        'ราคา ' + _selectedHairStylePrice.toString() + ' บาท',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

/////////////////////////////////////////////////////////////////////////
  Widget _buildDateSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMd().format(_selectedDate),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
            child: Text(
              'เลือกวันที่จอง',
              style: GoogleFonts.itim(),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCalendar() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('bookings')
          .where('date', isEqualTo: formattedDate)
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<QueryDocumentSnapshot> bookings = snapshot.data!.docs;
        return Column(
          children: [
            for (var index = 0; index < bookings.length; index++)
              Container(
                color: Colors.white,
                child: _buildBookingTile(bookings[index], index),
              ),
          ],
        );
      },
    );
  }

  bool _isBookingTimeValid(String bookingTime) {
    final now = DateTime.now();
    final bookingDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(
        '${DateFormat('yyyy-MM-dd').format(_selectedDate)} $bookingTime');
    return now.isBefore(bookingDateTime);
  }

  Widget _buildBookingTile(QueryDocumentSnapshot booking, int index) {
    final bookingData = booking.data() as Map<String, dynamic>;
    final bookedBy = bookingData['bookedBy'] ?? '';

    final currentUid = _auth.currentUser!.uid;
    bool isBooked = bookedBy != null && bookedBy == currentUid;
    bool isSlotAvailable = bookedBy.isEmpty;

    bool isBookingTimeValid = _isBookingTimeValid(bookingData['time'] ?? '');

    return ListTile(
      onTap: isSlotAvailable && isBookingTimeValid
          ? () async {
// ... (existing booking logic)
// Add your booking logic here
              QuerySnapshot userBooking = await _firestore
                  .collection('bookings')
                  .where('date',
                      isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDate))
                  .where('bookedBy', isEqualTo: currentUid)
                  .get();

              if (userBooking.docs.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('คุณได้จองคิวของวันนี้ไปแล้ว'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                await _showConfirmationDialog(
                  'ยืนยันการจอง',
                  'คุณแน่ใจใช่ไหมว่าจะจองช่วงเวลานี้?',
                  () async {
                    await _bookSlot(booking.reference, currentUid);
                  },
                );
              }
            }
          : isBooked
              ? () async {
// ... (existing cancel booking logic)

// Add your cancel booking logic here
                  await _showConfirmationDialog(
                    'ยกเลิกการจอง',
                    'คุณแน่ใจใช่ไหมที่จะยกเลิกการจองนี้?',
                    () async {
                      await _cancelBooking(booking.reference);
                    },
                  );
                }
              : null,
      title: Text('คิวที่ ${index + 1}: ${bookingData['time'] ?? ''}'),
      subtitle: bookedBy.isNotEmpty
          ? Text(
              isBooked ? 'คุณเป็นคนจองคิวนี้' : 'คิวนี้ถูกจองไปแล้ว',
            )
          : null,
      trailing: ElevatedButton(
        onPressed: isSlotAvailable && isBookingTimeValid
            ? () async {
// ... (existing booking logic)
// Add your booking logic here
                QuerySnapshot userBooking = await _firestore
                    .collection('bookings')
                    .where('date',
                        isEqualTo:
                            DateFormat('yyyy-MM-dd').format(_selectedDate))
                    .where('bookedBy', isEqualTo: currentUid)
                    .get();

                if (userBooking.docs.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('คุณได้จองคิวของวันนี้ไปแล้ว'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  await _showConfirmationDialog(
                    'ยืนยันการจอง',
                    'คุณแน่ใจใช่ไหมว่าจะจองช่วงเวลานี้?',
                    () async {
                      await _bookSlot(booking.reference, currentUid);
                    },
                  );
                }
              }
            : isBooked
                ? () async {
// Add your cancel booking logic here
                    await _showConfirmationDialog(
                      'ยกเลิกการจอง',
                      'คุณแน่ใจใช่ไหมที่จะยกเลิกการจองนี้?',
                      () async {
                        await _cancelBooking(booking.reference);
                      },
                    );
                  }
                : null,
        style: ElevatedButton.styleFrom(
          primary: isSlotAvailable && isBookingTimeValid
              ? Colors.green
              : isBooked
                  ? Colors.red
                  : Colors.grey,
// ... (existing button style)

          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          isSlotAvailable && isBookingTimeValid
              ? 'จองคิว'
              : isBooked
                  ? 'ยกเลิกจอง'
                  : isBookingTimeValid
                      ? 'จองไปแล้ว'
                      : 'เลยเวลาจอง',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
