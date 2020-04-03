import 'package:alphagarage/components/customTextField.dart';
import 'package:alphagarage/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MessageDialog {

  announce(context){
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
    return Container(
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
                  'Send\nMessage',
                  style: kAnnounceTextStyle.copyWith(fontSize: 38),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                placeholder: 'Title',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                placeholder: 'Write Message',
                minLines: 8,
                maxLines: null,
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
                          'Upload a picture',
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
                          'Send!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}