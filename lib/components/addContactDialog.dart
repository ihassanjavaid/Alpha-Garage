import 'package:alphagarage/components/customTextField.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alphagarage/screens/login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

  bool _showSpinner = false;
  Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Dialog(
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
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: AutoSizeText(
                              "Aggiungi utente",
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                            child: DropdownButton<String>(
                              value: this.dropdownButtonValue,
                              icon: Icon(Icons.people, color: Colors.brown),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.brown, fontSize: 24),
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
                              items: <String>[
                                'User',
                                'Admin'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: CustomTextField(
                      placeholder: 'Nome',
                      onChanged: (value) {
                        this.displayName = value;
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: CustomTextField(
                      placeholder: 'Email',
                      onChanged: (value) {
                        this.email = value;
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: CustomTextField(
                      placeholder: "Parola d'ordine",
                      isPassword: true,
                      onChanged: (value) {
                        this.password = value;
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Text(
                      "La password deve essere di almeno 8 caratteri",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ButtonTheme(
                    minWidth: double.maxFinite,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Aggiungi utente",
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
                      padding: EdgeInsets.only(
                          left: 38, right: 38, top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () async {
                        setState(() {
                          _showSpinner = true;
                        });
                        try {
                          await _auth.registerUser(
                              email: removeSpaces(this.email),
                              password: this.password);
                          await _auth.updateUserInfo(
                              displayName: this.displayName);
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
                        setState(() {
                          _showSpinner = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
