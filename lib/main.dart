import 'package:alphagarage/screens/announcement.dart';
import 'package:alphagarage/screens/contacts.dart';
import 'package:alphagarage/screens/index.dart';
import 'package:alphagarage/screens/login.dart';
import 'package:alphagarage/screens/userMessages.dart';
import 'package:flutter/material.dart';

void main() => runApp(Alfa());

class Alfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Alpha's Garage",
      debugShowCheckedModeBanner: false,
      initialRoute: Login.id,
      routes: {
        Login.id: (context) => Login(),
        Index.id: (context) => Index(
              screens: <Widget>[
                Announcement(),
                Contacts(),
              ],
            ),
        Contacts.id: (context) => Contacts(),
        Announcement.id: (context) => Announcement(),
        UserMessages.id: (context) => UserMessages(),
      },
    );
  }
}
