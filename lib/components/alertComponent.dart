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
            "Try Again!",
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