import 'package:flutter/material.dart';
import 'package:alphagarage/components/constants.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {

  @override
  Widget build(BuildContext context) {
    var _selectedIndex = 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: IndexedStack(
        index: _selectedIndex,
        //children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: kAnnouceIcon,
            title: Text(
              'Announcement',
              style: kBottomNavTextStyle,
            ),
            activeIcon: kAnnouceIconActive,
          ),
          BottomNavigationBarItem(
            icon: kPeopleIcon,
            title: Text(
              'People',
              style: kBottomNavTextStyle,
            ),
            activeIcon: kPeopleIconActive,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        //onTap: _onItemTapped,
        //backgroundColor: Colors.grey,
      ),
    );
  }
}
