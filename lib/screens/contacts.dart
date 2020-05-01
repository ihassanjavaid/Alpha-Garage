import 'package:alphagarage/components/sendMessage.dart';
import 'package:alphagarage/components/speedDialButton.dart';
import 'package:alphagarage/models/user_model.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  static const String id = 'contacts_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown,
        ),
        backgroundColor: Colors.white,
        title: AutoSizeText(
          'Le Utenza',
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: kAppBarTextStyle,
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SwipeList(),
      ),
      floatingActionButton: SpeedDialButton().showAdminSpeedDial(context),
    );
  }
}

class SwipeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListItemWidget();
  }
}

class ListItemWidget extends State<SwipeList> {
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final temp = await Auth().currentUser;
    setState(() {
      user = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.teal,
              ),
            );
          }
          final users = snapshot.data.documents;
          List<UserData> userList = [];
          for (var user in users) {
            final displayName = user['displayName'];
            final email = user['email'];
            final isAdmin = user['isAdmin'];
            UserData userData = UserData(
                displayName: displayName, email: email, isAdmin: isAdmin);
            userList.add(userData);
          }
          return Center(
            child: ListView.builder(
              itemCount: userList != null ? userList.length : 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SendMessageDialog();
                        });
                  },
                  child: Card(
                    elevation: 10,
                    child: Container(
                      height: 90.0,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: 70.0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: CircularProfileAvatar(
                                "",
                                backgroundColor: userList[index].isAdmin
                                    ? Colors.brown
                                    : Colors.grey,
                                initialsText: Text(
                                  userList != null
                                      ? userList[index].displayName[0]
                                      : 'A',
                                  style: TextStyle(
                                    fontSize: 42,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                elevation: 10.0,
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: AutoSizeText(
                                      userList != null
                                          ? userList[index].displayName
                                          : 'Anonymous User',
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.brown,
                                          fontWeight: userList[index].isAdmin
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child: Container(
                                        width:
                                            userList[index].isAdmin ? 68 : 58,
                                        decoration: BoxDecoration(
                                            color: userList[index].isAdmin
                                                ? Colors.brown
                                                : Colors.grey,
                                            border: Border.all(
                                                color: userList[index].isAdmin
                                                    ? Colors.brown
                                                    : Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            userList[index].isAdmin
                                                ? 'Admin'
                                                : 'Utene',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                      child: Container(
                                        width: 260,
                                        child: Text(
                                          "Clicca per messaggiare",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
