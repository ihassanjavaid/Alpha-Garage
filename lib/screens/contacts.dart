import 'package:alphagarage/components/sendMessage.dart';
import 'package:alphagarage/components/speedDialButton.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:alphagarage/utilities/userData.dart';

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
          'People',
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
  List<UserData> friendsDataList;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final tempHolder = await FirestoreService().getAllUsers();
    setState(() {
      friendsDataList = tempHolder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      itemCount: friendsDataList != null ? friendsDataList.length : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            MessageDialog(receiverEmail: friendsDataList[index].email)
                .announce(context);
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
                        backgroundColor: friendsDataList[index].isAdmin
                            ? Colors.brown
                            : Colors.grey,
                        initialsText: Text(
                          friendsDataList != null
                              ? friendsDataList[index].displayName[0]
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
                    //width: double.infinity,
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            friendsDataList != null
                                ? friendsDataList[index].displayName
                                : 'Anonymous User',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: 22,
                                fontStyle: FontStyle.italic,
                                color: Colors.brown,
                                fontWeight: friendsDataList[index].isAdmin
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Container(
                              width: 58,
                              decoration: BoxDecoration(
                                  color: friendsDataList[index].isAdmin
                                      ? Colors.brown
                                      : Colors.grey,
                                  border: Border.all(
                                      color: friendsDataList[index].isAdmin
                                          ? Colors.brown
                                          : Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Text(
                                friendsDataList[index].isAdmin
                                    ? 'Admin'
                                    : 'User',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: Container(
                              width: 260,
                              child: Text(
                                "Tap to message",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
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
    ));
  }
}
