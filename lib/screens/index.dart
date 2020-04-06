import 'package:flutter/material.dart';
import 'package:alphagarage/utilities/constants.dart';

class Index extends StatefulWidget {
  Index({this.screens});

  static const String id = 'index_screen';
  final List<Widget> screens;
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: kAnnouceIcon,
            title: Text(
              'Annuncio',
              style: kBottomNavTextStyle,
            ),
            activeIcon: kAnnouceIconActive,
          ),
          BottomNavigationBarItem(
            icon: kUserMessagesIcon,
            title: Text(
              'Messaggi',
              style: kBottomNavTextStyle,
            ),
            activeIcon: kUserMessagesIconActive,
          ),
          BottomNavigationBarItem(
            icon: kPeopleIcon,
            title: Text(
              'Le Utenza',
              style: kBottomNavTextStyle,
            ),
            activeIcon: kPeopleIconActive,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        onTap: _onItemTapped,
      ),
    );
  }
}
