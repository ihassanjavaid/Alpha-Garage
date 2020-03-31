import 'package:alphagarage/screens/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(Alfa());

class Alfa extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Alpha's Garage",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

