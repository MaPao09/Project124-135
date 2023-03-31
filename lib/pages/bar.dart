import 'dart:io';
import 'package:flutter/material.dart';
import 'package:miniproject/pages/hair_style_selection.dart';
import 'package:miniproject/pages/hair_styles_page.dart';
import 'package:miniproject/pages/profile.dart';

class Bar extends StatefulWidget {
  Bar({Key? key}) : super(key: key);

  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> {
  int _selectedIndex = 2;
  int? _previousIndex;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = index;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_previousIndex != null) {
      setState(() {
        _selectedIndex = _previousIndex!;
        _previousIndex = null;
      });
      return false;
    } else {
      return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ยืนยันการออกจากแอพ'),
                content: Text('คุณต้องการที่จะออกจากแอพใช่ไหม?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('ยกเลิก'),
                  ),
                  TextButton(
                    onPressed: () => exit(0),
                    child: Text('ยืนยัน'),
                  ),
                ],
              );
            },
          ) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [BookingPage(), ShowPage(), Profile()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/scissors.png'),
              label: 'จองคิว',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/home.png'),
              label: 'แนะนำทรงผม',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/hairstyle.png'),
              label: 'โปรไฟล์',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
        ),
      ),
    );
  }
}
