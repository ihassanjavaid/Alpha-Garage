import 'package:alphagarage/components/alertComponent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:alphagarage/components/customTextField.dart';
import 'package:alphagarage/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class Announcement extends StatefulWidget {
  static const String id = 'announcement_screen';

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  String announcementTitle;
  String announcementText;
  final messageTitleController = TextEditingController();
  final messageTextController = TextEditingController();
  File _image;
  StorageReference _firebaseStorageRef;
  bool _showSpinner = false;
  bool imageAttain = false;

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
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    // StorageReference reference = FirebaseStorage.instance.ref().child(path)
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 4,
                            child: AutoSizeText(
                              'Make an\nAnnouncement',
                              maxLines: 3,
                              overflow: TextOverflow.clip,
                              style: kAnnounceTextStyle,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                              child: Icon(
                                Icons.comment,
                                color: Colors.grey,
                                size: 52,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                  placeholder: 'Title',
                                  controller: this.messageTitleController,
                                  onChanged: (value) {
                                    this.announcementTitle = value;
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                  placeholder: 'Make an Announcement',
                                  minLines: 8,
                                  maxLines: null,
                                  controller: this.messageTextController,
                                  onChanged: (value) {
                                    this.announcementText = value;
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ButtonTheme(
                                  minWidth: double.infinity,
                                  height: 50,
                                  child: RaisedButton(
                                    color: _image != null ?
                                    Colors.blueAccent : Colors.grey,
                                    elevation: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          _image != null ?
                                          Icons.done_all :
                                          Icons.satellite,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            _image != null ?
                                                'Image Uploaded' :
                                            'Upload an Image',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await getImage();
                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> uploadScreen(),));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
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
                                  'Announce!',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            _showSpinner = true;
                            // Post announcement
                            try {
                              var imageReference;
                              if (_image != null) {
                                await uploadImage(context);
                                imageReference =
                                    await _firebaseStorageRef.getDownloadURL();
                              }

                              await FirestoreService().postMessage(
                                messageTitle: this.announcementTitle,
                                messageText: this.announcementText,
                                messageType: MessageType.announcement,
                                imageReference: imageReference,
                              );
                              messageTextController.clear();
                              messageTitleController.clear();
                              _image = null;
                              _firebaseStorageRef = null;
                              setState(() {
                                _image = null;
                              });
                              AlertComponent().announcementMade(context).show();
                            } catch (e) {
                              print(e);
                            }
                            _showSpinner = false;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class uploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(),
    );
  }
}
