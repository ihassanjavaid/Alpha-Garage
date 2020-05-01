import 'package:alphagarage/components/message_bubble.dart';
import 'package:alphagarage/models/user_model.dart';
import 'package:alphagarage/services/auth_service.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:alphagarage/models/message_model.dart';

class ConversationScreen extends StatelessWidget {
  static const String id = "conversation_screen";
  final UserData user;
  final List<Message> chatMessages;
  ConversationScreen({this.user, this.chatMessages});

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
                child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    Message message = this.chatMessages[index];
                    return MessageBubble(
                      messageText: message.messageText,
                      timestamp:
                          DateTime.fromMillisecondsSinceEpoch(message.timestamp)
                              .toString(),
                      isMe: message.messageSender != this.user.email,
                    );
                  },
                  itemCount: this.chatMessages.length,
                ),
              ),
            ),
            /*StreamBuilder<QuerySnapshot>(
              stream:
                  FirestoreService().firestore.collection('chats').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data.documents.reversed;
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  final messageText = message['messageText'];
                  final messageSender = message['messageSender'];
                  final timestamp = message['timestamp'];

                  final MessageBubble messageBubble = MessageBubble(
                    messageText: messageText,
                    isMe: widget.user.email == messageSender,
                    timestamp: timestamp,
                  );
                  messageBubbles.add(messageBubble);
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    children: messageBubbles,
                  ),
                );
              },
            )*/
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
