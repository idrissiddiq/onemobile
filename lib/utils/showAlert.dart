import 'package:flutter/material.dart';
import '/home.dart';

void showAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(        
        title: Text('Failed'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF993C),
                ),
          ),
        ],
      );
    },
  );
}

void surveyErrorAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(        
        title: Text('Failed'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Close'),
            onPressed: () {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: "asdsada", username: "asdsada")));
            },
            style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF993C),
                ),
          ),
        ],
      );
    },
  );
}