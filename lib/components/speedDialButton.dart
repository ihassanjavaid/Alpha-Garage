import 'package:alphagarage/components/addContactDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpeedDialButton{

  showButton(context){
    return SpeedDial(
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 29.0),
      visible: true,
      closeManually: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 1,
      //onOpen: () => print('OPENING DIAL'),
      //onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
      elevation: 10.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.doorOpen),
          backgroundColor: Colors.red,
          label: 'Sign out',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            // TODO Add Sign out functionality
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add),
          backgroundColor: Colors.green,
          label: 'Add User',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            ContactDialog().addContact(context);
          },
        ),
      ],
    );
  }

  logOutButtonOnly(){
    return SpeedDial(
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 29.0),
      visible: true,
      closeManually: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 1,
      //onOpen: () => print('OPENING DIAL'),
      //onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
      elevation: 10.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.doorOpen),
          backgroundColor: Colors.red,
          label: 'Sign out',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            // TODO Add Sign out functionality
          },
        ),
      ],
    );
  }
}