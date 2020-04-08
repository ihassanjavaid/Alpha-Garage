import 'package:alphagarage/components/customTextField.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class SendMessageDialog extends StatefulWidget {
  SendMessageDialog({this.receiverEmail});

  final String receiverEmail;

  @override
  _SendMessageDialogState createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SendMessageDialog> {
  final FirestoreService _firestoreService = FirestoreService();
  final messageTitleController = TextEditingController();
  final messageTextController = TextEditingController();
  File _image;
  bool _showSpinner = false;
  StorageReference _firebaseStorageRef;

  Future<void> getImage() async {
    final status = await Permission.photos.request();

    if (status == PermissionStatus.granted) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;

        print('Image path $_image');
      });
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    String fileName = basename(_image.path);
    _firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = _firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;

    // StorageReference reference = FirebaseStorage.instance.ref().child(path)
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: _announcementCard(context),
    );
  }

  _announcementCard(context) {
    String messageTitle;
    String messageText;

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Container(
        height: 540,
        child: Padding(
          padding: EdgeInsets.all(10.0),
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
                padding: EdgeInsets.all(8.0),
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
                    color: _image != null ? Colors.blueAccent : Colors.grey,
                    elevation: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          _image != null ? Icons.done_all : Icons.satellite,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _image != null
                                ? 'Foto Caricata'
                                : 'Caricare una Foto',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      await getImage();
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
                        var imageReference;
                        if (_image != null) {
                          await uploadImage(context);
                          imageReference =
                              await _firebaseStorageRef.getDownloadURL();
                        }
                        await _firestoreService.postMessage(
                            messageTitle: messageTitle,
                            messageText: messageText,
                            receiverEmail: widget.receiverEmail,
                            imageReference: imageReference,
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

class MessageDialog {
  MessageDialog({this.receiverEmail});

  final String receiverEmail;
  final FirestoreService _firestoreService = FirestoreService();
  final messageTitleController = TextEditingController();
  final messageTextController = TextEditingController();
  File _image;
  bool _showSpinner = false;
  StorageReference _firebaseStorageRef;

  Future<void> getImage() async {
    final status = await Permission.photos.request();

    if (status == PermissionStatus.granted) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      _image = image;
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    String fileName = basename(_image.path);
    _firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = _firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;
  }

  announce(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: _announcementCard(context),
          );
        });
  }

  _announcementCard(context) {
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
                    onPressed: () async {
                      await getImage();
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
                        var imageReference;
                        if (_image != null) {
                          await uploadImage(context);
                          imageReference =
                              await _firebaseStorageRef.getDownloadURL();
                        }
                        await _firestoreService.postMessage(
                            messageTitle: messageTitle,
                            messageText: messageText,
                            receiverEmail: this.receiverEmail,
                            imageReference: imageReference,
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
