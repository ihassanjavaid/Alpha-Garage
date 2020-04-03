import 'package:alphagarage/components/addContactDialog.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:alphagarage/utilities/userData.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          'Contacts',
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: kAppBarTextStyle,
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SwipeList(),
      ),
      floatingActionButton: SpeedDial(
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 29.0),
        visible: true,
        closeManually: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.white,
        overlayOpacity: 1,
        //onOpen: () => print('OPENING DIAL'),
        //onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 10.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.doorOpen),
              backgroundColor: Colors.red,
              label: 'Sign out',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                // TODO Add Sign out functionality
              },
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            backgroundColor: Colors.green,
            label: 'Add User',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              ContactDialog().addContact(context);
            },
          ),
        ],
      ),

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
  //UserData userData;
  //final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final tempHolder = await FirestoreService().getAllUsers();
    for (UserData user in tempHolder) {
      print(user.displayName);
      print(user.email);
    }
    setState(() {
      friendsDataList = tempHolder;
    });
  }

  /*void getFriends() async {
    String reducedPhoneNum;
    //List<Contact> contacts = await ContactsClass.getContacts();

    for (var contact in contacts) {
      contact.phones.forEach((phoneNum) async {
        reducedPhoneNum = phoneNum.value.replaceAll(" ", "");
        reducedPhoneNum = reducedPhoneNum.replaceAll("-", "");

        final QuerySnapshot query =
        await _firestoreService.getUserDocuments(reducedPhoneNum);

        for (var document in query.documents) {
          setState(() {
            this.friendsDataList.add(document.data);
          });
        }
        print('Total friends:');
        print(this.friendsDataList.length);
      });
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    //_acquireUserData();
    return Container(
        child: ListView.builder(
      itemCount: friendsDataList != null ? friendsDataList.length : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
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
//                borderColor: Colors.brown,
//                borderWidth: 3,
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
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Container(
                              width: 58,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(color: Colors.green),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Text(
                                "Worker",
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
                                // TODO add message functionality
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
        /*Dismissible(
              key: Key(items[index]),
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.brown,
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);

                });
              },
              direction: DismissDirection.endToStart,
              child: Card(
                elevation: 10,
                child: Container(
                  height: 90.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 70.0,
                        width: 70.0,
                        child: CircularProfileAvatar(
                          "",
                          backgroundColor: Colors.grey,
                          initialsText: Text(
                            items[index] != null ? items[index][0] : "",
                            style: TextStyle(
                              fontSize: 42,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          elevation: 10.0,
//                borderColor: Colors.brown,
//                borderWidth: 3,
                        ),
                        /*decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://i.ya-webdesign.com/images/funny-png-avatar-2.png")
                        ),
                    ),*/
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
                                items[index],
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.brown,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(color: Colors.green),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                                  child: Text(
                                    "Online",
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
                                    "Swipe to delete ←",
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
            );*/
      },
    ));
  }

/*  void _acquireUserData() async {
    final data = await _firestoreService.getCurrentUserData();
    setState(() {
      userData = data;
    });
  }*/
}
