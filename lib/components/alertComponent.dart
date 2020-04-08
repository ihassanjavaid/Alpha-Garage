import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertComponent{

  generateAlert({ @required context, @required title, @required description}){
    return Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          color: Colors.brown,
          child: Text(
            "Riprova!",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 130,
        )
      ],
    );
  }

  announcementMade(context){
    return Alert(
      context: context,
      type: AlertType.success,
      title: 'Annunciato!',
      desc: 'è stato fatto un annuncio',
      buttons: [
        DialogButton(
          color: Colors.brown,
          child: Text(
            "Fatto!",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 130,
        )
      ],
    );
  }

}