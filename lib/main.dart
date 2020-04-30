import 'package:alphagarage/models/user_model.dart';
import 'package:alphagarage/screens/announcement.dart';
import 'package:alphagarage/screens/contacts.dart';
import 'package:alphagarage/screens/index.dart';
import 'package:alphagarage/screens/login.dart';
import 'package:alphagarage/screens/userMessages.dart';
import 'package:alphagarage/widgets/recent_chats.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alphagarage/screens/chat_screen.dart';

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
                RecentChats(),
                Contacts(),
              ],
            ),
        Contacts.id: (context) => Contacts(),
        Announcement.id: (context) => Announcement(),
        RecentChats.id: (context) => RecentChats(),
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
    final bool isAdmin = pref.getBool('isAdmin');



    if (userId != null) {
      print('Logged in automatically');
      if (isAdmin ?? false)
        Navigator.pushReplacementNamed(context, Index.id);
      else
        Navigator.pushReplacementNamed(context, UserMessages.id);
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
