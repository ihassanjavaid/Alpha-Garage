import 'package:alphagarage/models/user_model.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alphagarage/screens/conversation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alphagarage/models/message_model.dart';

class ChatsScreen extends StatefulWidget {
  static String id = "chats_screen";

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  FirestoreService _firestoreService = FirestoreService();

  getItems() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final bool isAdmin = pref.getBool('isAdmin');

//    await getChats();
    try {
      if (isAdmin) {
        return await _firestoreService.getNonAdminUsers();
      } else {
        return await _firestoreService.getAllAdmins();
      }
    } catch (e) {
      print('Failed to get users\n$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown,
        ),
        backgroundColor: Colors.white,
        title: AutoSizeText('Chiacchierare',
            overflow: TextOverflow.clip, maxLines: 1, style: kAppBarTextStyle),
        centerTitle: false,
      ),
      body: FutureBuilder(
          future: getItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().firestore
                  .collection('chats')
                  .snapshots(),
              builder: (context, chatSnapshot)  {

                List<Message> messagesList = [];
                final newChat = chatSnapshot.data.documentChanges;
                newChat.forEach((chat) {
                  Message message = Message.fromMap(chat.document.data);
                  messagesList.add(message);
                });

                return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  List<UserData> users = snapshot.data;
                  final UserData user = users[index];
                  return StreamBuilder(
                      stream: _firestoreService.firestore
                          .collection('chats')
                          .snapshots(),
                      builder: (context, snapshotDoc) {
                        if (snapshotDoc.hasData) {
                        final chats = snapshotDoc.data.documents.reversed;
                        List<Message> _chatMessages = [];
                        for (var chat in chats) {
                          Message message = Message.fromMap(chat.data);
                          _chatMessages.add(message);
                        }
                        List userChatMessages = _chatMessages.where((message) => message.messageSender == user.email || message.messageReceiver == user.email ).toList();
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConversationScreen(
                                user: user,
                              ),
                            ),
                          ),
                         /* child: Card(
                            elevation: 10,
                            margin: EdgeInsets.only(
                                top: 5.0, bottom: 5.0, right: 5.0, left: 5.0),
                            child: Container(
                              width: 70,
                              height: 90,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 80,
                                        width: 80,
                                        child: CircularProfileAvatar(
                                          "",
                                          backgroundColor: Colors.grey,
                                          initialsText: Text(
                                            user.displayName[0],
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          elevation: 10.0,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            user.displayName,
                                            style: TextStyle(
                                              color: Colors.brown,
                                              fontSize: 22.0,
                                              // fontWeight: chat.unread ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                          // SizedBox(height: 5.0),
                                          // Container(
                                          //   width: MediaQuery.of(context).size.width * 0.45,
                                          //   child: Text(
                                          //     chat.text,
                                          //     style: TextStyle(
                                          //       color: Colors.black45,
                                          //       fontSize: 18.0,
                                          //       fontWeight:  chat.unread ? FontWeight.bold : FontWeight.normal,
                                          //     ),
                                          //     overflow: TextOverflow.ellipsis,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Column(
                                  //   children: <Widget>[
                                  //     Text(
                                  //       chat.time,
                                  //       style: TextStyle(
                                  //         color: Colors.grey,
                                  //         fontSize: 15.0,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     SizedBox(height: 5.0),
                                  //     chat.unread
                                  //         ? Container(
                                  //             width: 40.0,
                                  //             height: 20.0,
                                  //             decoration: BoxDecoration(
                                  //               color: Colors.brown,
                                  //               borderRadius: BorderRadius.circular(5.0),
                                  //             ),
                                  //             alignment: Alignment.center,
                                  //             child: Text(
                                  //               'NEW',
                                  //               style: TextStyle(
                                  //                 color: Colors.white,
                                  //                 fontSize: 12.0,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //             ),
                                  //           )
                                  //         : Text(''),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),*/
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
                                        backgroundColor: Colors.grey,
                                        initialsText: Text(
                                          user.displayName[0]
                                              .toUpperCase(),
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
                                             user.displayName,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.brown,
                                                  fontWeight: FontWeight.normal,
                                                  ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                              child: Container(
                                                width:
                                               58,
                                                decoration: BoxDecoration(
                                                    color:
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
                                                        fontSize: 14,
                                                        fontStyle: FontStyle.italic),
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
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      });
                },
              )}
            );
          }),
    );
  }
}
