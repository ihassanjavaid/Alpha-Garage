import 'package:alphagarage/components/speedDialButton.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserMessages extends StatefulWidget {
  static const String id = 'user_messages_screen';
  @override
  _UserMessagesState createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {
  final _firestore = Firestore.instance;

  refresh() {
    setState(() {
      // TODO Add refresh functionality
      // How to make this function and call this from the Speed Dial class
    });
  }

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final temp = await Auth().getCurrentUser();
    setState(() {
      this.currentUser = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown,
        ),
        backgroundColor: Colors.white,
        title: AutoSizeText('Announcements',
            overflow: TextOverflow.clip, maxLines: 1, style: kAppBarTextStyle),
        centerTitle: false,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('messages').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            final messages = snapshot.data.documents;
            List<AnnouncementBubble> messageBubbles = [];
            for (var message in messages) {
              final messageTitle = message.data['messageTitle'];
              final messageText = message.data['messageText'];
              final messageType = message.data['messageType'];
              if (messageType == 'privateMessage') {
                try {
                  if (currentUser.email != message['receiverEmail']) continue;
                } catch (_) {}
              }
              final messageWidget = AnnouncementBubble(
                messageTitle: messageTitle,
                messageText: messageText,
              );
              messageBubbles.add(messageWidget);
            }
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            );
          },
        ),
      ),
      floatingActionButton: SpeedDialButton().showUserSpeedDial(context),
    );
  }
}

class AnnouncementBubble extends StatelessWidget {
  AnnouncementBubble(
      {this.messageText, this.messageTitle, this.isPrivate = false});

  final String messageText;
  final String messageTitle;
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            messageTitle != null ? messageTitle : '',
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.brown,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Material(
              borderRadius: BorderRadius.circular(8.5),
              elevation: 5.0,
              color: !isPrivate ? Colors.grey : Colors.redAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  messageText != null ? messageText : '',
                  style: TextStyle(
                    fontSize: 16.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            thickness: 3.0,
          ),
        ],
      ),
    );
  }
}
