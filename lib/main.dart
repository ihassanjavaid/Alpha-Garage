import 'package:alphagarage/screens/announcement.dart';
import 'package:alphagarage/screens/contacts.dart';
import 'package:alphagarage/screens/index.dart';
import 'package:alphagarage/screens/login.dart';
import 'package:alphagarage/screens/userMessages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Alfa());

class Alfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Alpha's Garage",
      debugShowCheckedModeBanner: false,
      initialRoute: RouteDecider.id,
      routes: {
        RouteDecider.id: (context) => RouteDecider(),
        Login.id: (context) => Login(),
        Index.id: (context) => Index(
              screens: <Widget>[
                Announcement(),
                UserMessages(),
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

// TODO fix the Android app Icon through ImageAsset
class RouteDecider extends StatelessWidget {
  static const String id = 'route_decider';

  void autoLogin(context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String userId = pref.getString('email');

    if (userId != null) {
      print('Logged in automatically');
      Navigator.pushReplacementNamed(context, Index.id);
      return;
    } else {
      print('First time sign in');
      Navigator.pushReplacementNamed(context, Login.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    autoLogin(context);
    return Container();
  }
}
