import 'package:alphagarage/components/customTextField.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alphagarage/screens/login.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  // Data Attributes
  String email;
  String password;
  String displayName;
  String dropdownButtonValue = 'User';

  Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        height: 450,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      child: Text(
                        "Add User",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                      child: DropdownButton<String>(
                        value: this.dropdownButtonValue,
                        icon: Icon(Icons.people, color: Colors.brown),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.brown, fontSize: 24),
                        underline: SizedBox(
                          width: double.maxFinite,
                          child: Container(
                            height: 2,
                            color: Colors.brown,
                          ),
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            this.dropdownButtonValue = newValue;
                          });
                        },
                        items: <String>['User', 'Admin']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: CustomTextField(
                  placeholder: 'Name',
                  onChanged: (value) {
                    this.displayName = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: CustomTextField(
                  placeholder: 'Email',
                  onChanged: (value) {
                    this.email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: CustomTextField(
                  placeholder: 'Password',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Add User",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(Icons.person_add),
                      )
                    ],
                  ),
                  color: Colors.brown,
                  textColor: Colors.white,
                  padding:
                      EdgeInsets.only(left: 38, right: 38, top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () async {
                    try {
                      await _auth.registerUser(
                          email: removeSpaces(this.email),
                          password: this.password);
                      await _auth.updateUserInfo(displayName: this.displayName);
                      await FirestoreService().registerUser(
                          email: removeSpaces(this.email),
                          displayName: this.displayName,
                          isAdmin: this.dropdownButtonValue == 'Admin'
                              ? true
                              : false);
                      //Navigator.popAndPushNamed(context, Index.id);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                      // just for now TODO remove this
                      Navigator.pop(context);
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

class ContactDialog {
  // Data Attributes
  String email;
  String password;
  String displayName;

  Auth _auth = Auth();

  String removeSpaces(String email) => email.replaceAll(' ', '');

  addContact(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: _addUserContainer(context),
          );
        });
  }

  Widget _addUserContainer(BuildContext context) {
    return Container(
      height: 450,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                    child: Text(
                      "Add User",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                    child: DropdownButton<String>(
                      value: 'User',
                      icon: Icon(Icons.people, color: Colors.brown),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.brown, fontSize: 24),
                      underline: SizedBox(
                        width: double.maxFinite,
                        child: Container(
                          height: 2,
                          color: Colors.brown,
                        ),
                      ),
                      onChanged: (String newValue) {
                        /*setState(() {
                    dropdownValue = newValue;
                });*/
                      },
                      items: <String>['User', 'Admin']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: CustomTextField(
                placeholder: 'Name',
                onChanged: (value) {
                  this.displayName = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: CustomTextField(
                placeholder: 'Email',
                onChanged: (value) {
                  this.email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: CustomTextField(
                placeholder: 'Password',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Add User",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Icon(Icons.person_add),
                    )
                  ],
                ),
                color: Colors.brown,
                textColor: Colors.white,
                padding:
                    EdgeInsets.only(left: 38, right: 38, top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  try {
                    await _auth.registerUser(
                        email: removeSpaces(this.email),
                        password: this.password);
                    await _auth.updateUserInfo(displayName: this.displayName);
                    await FirestoreService().registerUser(
                        email: removeSpaces(this.email),
                        displayName: this.displayName);
                    //Navigator.popAndPushNamed(context, Index.id);
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                    // just for now TODO remove this
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
