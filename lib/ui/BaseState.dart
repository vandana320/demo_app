import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  ///
  /// Show alert dialog
  ///
  void showAlertDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: title == null ? null : new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showConfirmAlertDialog(
      String title, String message, VoidCallback confirmCallback,
      {String confirmTitle = "ok",
      VoidCallback cancelCallback,
      String cancelTitle = "cancel"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancelCallback != null) {
                  cancelCallback();
                }
              },
            ),
            new FlatButton(
              child: new Text(
                "Confirm",
              ),
              onPressed: () {
                Navigator.of(context).pop();
                confirmCallback();
              },
            ),
          ],
        );
      },
    );
  }
}
