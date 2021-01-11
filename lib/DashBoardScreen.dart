import 'package:demo_app/ui/BaseState.dart';
import 'package:demo_app/util/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => new _DashBoardScreenState();
}

class _DashBoardScreenState extends BaseState<DashBoardScreen> {
  String email = "";
  String firstName = "";
  String lastName = "";

  @override
  void initState() {
    SessionManager().getLoginUserFirstName().then((_) {
      setState(() {
        firstName = _;
      });
    });
    SessionManager().getLoginUserLastName().then((_) {
      setState(() {
        lastName = _;
      });
    });
    SessionManager().getLoginUserEmail().then((_) {
      setState(() {
        email = _;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget firstNameWidget = Text("FirstName: $firstName");
    Widget lastNameWidget = Text("LastName: $lastName");
    Widget emailNameWidget = Text("EmailID: $email");
    Widget _logutWidget = Padding(
        padding: EdgeInsets.only(top: 26.0),
        child: RaisedButton(
            onPressed: _logout,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text("Logout", style: TextStyle(color: Colors.black),)));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              firstNameWidget,
              lastNameWidget,
              emailNameWidget,
              _logutWidget
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}
