import 'package:alphagarage/components/alertComponent.dart';
import 'package:alphagarage/components/customTextField.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MessageDialog {
  MessageDialog({this.receiverEmail});

  final String receiverEmail;
  final FirestoreService _firestoreService = FirestoreService();
  final messageTitleController = TextEditingController();
  final messageTextController = TextEditingController();

  bool _showSpinner = false;

  announce(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: _announcementCard(),
          );
        });
  }

  _announcementCard() {
    String messageTitle;
    String messageText;

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Container(
        height: 540,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    'Invia\nMessaggio',
                    style: kAnnounceTextStyle.copyWith(fontSize: 38),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  placeholder: 'Titolo',
                  controller: this.messageTitleController,
                  onChanged: (value) {
                    messageTitle = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  placeholder: 'Scrivi un messaggio',
                  minLines: 8,
                  maxLines: null,
                  controller: this.messageTextController,
                  onChanged: (value) {
                    messageText = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.grey,
                    elevation: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.satellite,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Carica una foto',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // TODO add functonality
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ButtonTheme(
                  minWidth: double.maxFinite,
                  height: 50,
                  child: RaisedButton(
                    focusColor: Colors.brown,
                    autofocus: true,
                    color: Colors.brown,
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Spedire!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      _showSpinner = true;
                      // Push the message to the contact
                      try {
                        await _firestoreService.postMessage(
                            messageTitle: messageTitle,
                            messageText: messageText,
                            receiverEmail: this.receiverEmail,
                            messageType: MessageType.privateMessage);
                        this.messageTitleController.clear();
                        this.messageTextController.clear();
                      } catch (e) {
                        print(e);
                      }
                      _showSpinner = false;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
