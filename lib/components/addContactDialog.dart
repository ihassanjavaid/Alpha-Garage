import 'package:alphagarage/components/customTextField.dart';
import 'package:alphagarage/screens/index.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AddContact{

  // Data Attributes
  String email;
  String password;
  String displayName;

  Auth _auth = Auth();

  String removeSpaces(String email) => email.replaceAll(' ','');

  addContact(context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(5.0),
            ),
            child: signUpCard(context),
          );
        });
  }

  Widget signUpCard(BuildContext context) {

    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Add User",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: CustomTextField(
                  placeholder: 'Your Name',
                  onChanged: (value) {
                    this.displayName = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: CustomTextField(
                  placeholder: 'Your Email',
                  onChanged: (value) {
                    this.email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: CustomTextField(
                  placeholder: 'Your Password',
                  isPassword: true,
                  onChanged: (value) {
                    this.password = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Text(
                  "Password must be at least 8 characters and include a special character and number",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ButtonTheme(
                minWidth: double.maxFinite,
                child: FlatButton(
                  child: Text("Add User"),
                  color: Colors.brown,
                  textColor: Colors.white,
                  padding: EdgeInsets.only(
                      left: 38, right: 38, top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () async {
                    try {
                      await _auth.registerUser(
                          email: removeSpaces(this.email), password: this.password);
                      await _auth.updateUserInfo(
                          displayName: this.displayName);
                      await FirestoreService().registerUser(
                          email: removeSpaces(this.email), displayName: this.displayName);
                      //Navigator.popAndPushNamed(context, Index.id);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}