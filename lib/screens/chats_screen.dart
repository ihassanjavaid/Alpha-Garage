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
                stream: FirestoreService()
                    .firestore
                    .collection('chats')
                    .snapshots(),
                builder: (context, chatSnapshot) {
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
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationScreen(
                              user: user,
                            ),
                          ),
                        ),
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
                                    padding: const EdgeInsets.fromLTRB(
                                        2, 0, 0, 0),
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
                                      elevation: 2.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        10, 2, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: AutoSizeText(
                                            user.displayName,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontStyle:
                                              FontStyle.italic,
                                              color: Colors.brown,
                                              fontWeight: isChatofUser(
                                                  messagesList,
                                                  user)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(
                                                0, 3, 0, 3),
                                            child: Container(
                                              width: isChatofUser(messagesList, user) ? 60 : 70,
                                              decoration: BoxDecoration(
                                                  color: isChatofUser(
                                                      messagesList,
                                                      user)
                                                      ? Colors.brown
                                                      : Colors.grey,
                                                  border: Border.all(
                                                      color: isChatofUser(
                                                          messagesList,
                                                          user)
                                                          ? Colors.brown
                                                          : Colors.grey),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius
                                                          .circular(
                                                          10))),
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  isChatofUser(
                                                      messagesList,
                                                      user)
                                                      ? 'Nuovo'
                                                      : 'Vecchio',
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                      color:
                                                      Colors.white,
                                                      fontSize: 14,
                                                      fontStyle:
                                                      FontStyle
                                                          .italic),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(
                                                0, 2, 0, 2),
                                            child: Container(
                                              width: 260,
                                              child: Text(
                                                "Toccare per aprire",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontStyle:
                                                  FontStyle.italic,
                                                  fontWeight: isChatofUser(
                                                      messagesList,
                                                      user)
                                                      ? FontWeight.bold
                                                      : FontWeight
                                                      .normal,
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
                  );
                });
          }),
    );
  }

  bool isChatofUser(List<Message> chats, UserData user) {
    for (var chat in chats) {
      if (chat.messageReceiver == user.email) return true;
    }
    return false;
  }
}
