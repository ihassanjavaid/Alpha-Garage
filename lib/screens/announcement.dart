import 'package:flutter/material.dart';
import 'package:alphagarage/components/constants.dart';
import 'package:alphagarage/components/customTextField.dart';

class Announcement extends StatefulWidget {
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Announcement',
                      style: kAnnounceTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Icon(
                        Icons.comment,
                        color: Colors.brown,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextField(
                            placeholder: 'Title',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextField(
                            placeholder: 'Make an Announcement',
                            minLines: 8,
                            maxLines: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                      'Upload a picture',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: double.infinity,
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
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ],
            ),
          ),
          ),
      ),
    );
  }
}
