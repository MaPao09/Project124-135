import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowPage extends StatefulWidget {
  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Sprite Barber',
          style: GoogleFonts.itim(
            textStyle: const TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
      ),
      body: Container(
        color: Colors.yellow[100],
        child: Column(
          children: [
            Container(
              color: Colors.yellow[200],
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'ทรงผมแนะนำ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _buildHairStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHairStyle() {
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

            return Card(
              color: Colors.yellow[200],
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
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: Text(
                                'ราคา ' + price + ' บาท',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
            );
          },
        );
      },
    );
  }
}
