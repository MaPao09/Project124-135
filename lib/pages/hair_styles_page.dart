import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowPage extends StatefulWidget {
  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<DocumentSnapshot> _hairstyles = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMoreData) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      querySnapshot = await _firestore
          .collection('hairstyles')
          .orderBy('name')
          .limit(_pageSize)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('hairstyles')
          .orderBy('name')
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      setState(() {
        _hairstyles.addAll(querySnapshot.docs);
      });
    } else {
      _hasMoreData = false;
    }

    setState(() {
      _isLoading = false;
    });
  }

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
                  fontSize: 25,
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
    return ListView.builder(
      controller: _scrollController,
      itemCount: _hairstyles.length + (_isLoading ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index < _hairstyles.length) {
          final hairstyleData =
              _hairstyles[index].data() as Map<String, dynamic>;
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
                      SizedBox(height: 4),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
