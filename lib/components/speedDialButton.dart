import 'package:alphagarage/components/addContactDialog.dart';
import 'package:alphagarage/models/user_model.dart';
import 'package:alphagarage/screens/chat_screen.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/widgets/recent_chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alphagarage/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeedDialButton {
  showAdminSpeedDial(context) {
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
      tooltip: 'Press to Add user or Sign out',
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
      elevation: 10.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.doorOpen),
          backgroundColor: Colors.red,
          label: 'Disconnessione',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () async {
            final SharedPreferences pref =
                await SharedPreferences.getInstance();
            await pref.remove('email');

            await Auth().signOut();
            Navigator.pushReplacementNamed(context, Login.id);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add),
          backgroundColor: Colors.green,
          label: 'Aggiungi Utente',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AddContact());
          },
        ),
      ],
    );
  }

  showUserSpeedDial(context) {
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
      tooltip: 'Press to Refresh or Sign out',
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
      elevation: 10.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.doorOpen),
          backgroundColor: Colors.red,
          label: 'Disconnessione',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () async {
            final SharedPreferences pref =
                await SharedPreferences.getInstance();
            await pref.remove('email');

            await Auth().signOut();
            Navigator.pushReplacementNamed(context, Login.id);
          },
        ),
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.comments),
          backgroundColor: Colors.green,
          label: 'Chiacchierare',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Navigator.pushNamed(context, RecentChats.id);
          },
        ),
      ],
    );
  }
}
