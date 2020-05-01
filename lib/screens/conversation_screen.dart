import 'package:alphagarage/components/message_bubble.dart';
import 'package:alphagarage/models/user_model.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:alphagarage/models/message_model.dart';

class ConversationScreen extends StatelessWidget {
  static const String id = "conversation_screen";
  final UserData user;
  
  ConversationScreen({this.user});

  final messageTextController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    String _message = '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown,
        ),
        backgroundColor: Colors.white,
        title: AutoSizeText(
          this.user.displayName,
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: kAppBarTextStyle,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreService().firestore
                        .collection('chats').orderBy('timestamp')
                        .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('No messages yet\nOr no internet connection'),
                      );
                    }

                    final messages = snapshot.data.documents.reversed;
                    List<MessageBubble> messageBubbles = [];
                    for (var message in messages) {
                      Message chatMessage = Message.fromMap(message.data);
                      if (chatMessage.messageSender == this.user.email || chatMessage.messageReceiver == this.user.email) {
                        MessageBubble messageBubble = MessageBubble(
                          messageText: chatMessage.messageText,
                          timestamp: DateTime.fromMillisecondsSinceEpoch(chatMessage.timestamp).toString(),
                          isMe: chatMessage.messageSender == user.email,
                        );
                        messageBubbles.add(messageBubble);
                      }
                    }
                    return Expanded(child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0,),
                      children: messageBubbles,
                    ),);
                  },
                ),
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        _message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      final currentUser = await Auth().currentUser;
                      // Create the message
                      Message newMessage = Message(
                        messageSender: currentUser.email,
                        messageReceiver: this.user.email,
                        messageText: _message,
                        timestamp: DateTime.now().millisecondsSinceEpoch,
                      );
                      
                    },
                    child:
                        /*Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    )*/
                        Icon(
                      Icons.send,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ListView.builder(
//                   reverse: true,
//                   itemBuilder: (context, index) {
//                     Message message = this.chatMessages[index];
//                     return MessageBubble(
//                       messageText: message.messageText,
//                       timestamp:
//                           DateTime.fromMillisecondsSinceEpoch(message.timestamp)
//                               .toString(),
//                       isMe: message.messageSender != this.user.email,
//                     );
//                   },
//                   itemCount: this.chatMessages.length,
//                 )