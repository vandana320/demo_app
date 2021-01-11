import 'dart:async';
import 'dart:io';
import 'package:demo_app/model/LoginResponse.dart';
import 'package:demo_app/model/ServerResponse.dart';
import 'package:demo_app/net/RestServerApi.dart';
import 'package:demo_app/ui/BaseState.dart';
import 'package:demo_app/util/CommonUtil.dart';
import 'package:demo_app/util/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _saving = false;
  String _password;
  String _email = "";
  bool canCheckBiometrics;

  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();

  var localAuth = LocalAuthentication();

  List<BiometricType> availableBiometrics;
  String authString = "";

  @override
  void initState() {
    super.initState();
    localAuth.canCheckBiometrics.then((_) {
      setState(() {
        canCheckBiometrics = _;
      });
    });
    localAuth.getAvailableBiometrics().then((_) {
      setState(() {
        availableBiometrics = _;
      });
    });

    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        authString = "Unlock FaceID";
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        authString = "Unlock Finger-Print";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget email = Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 10.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailFieldController,
          validator: (value) {
            if (value.isEmpty) return "Please enter email";
            if (!CommonUtil.isValidEmail(value))
              return "Please enter valid email";
            return null;
          },
          onSaved: (value) => _email = value,
          decoration: InputDecoration(
            icon: const Icon(Icons.email),
            labelText: "Email",
          ),
        ));

    final password = Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10.0),
      child: TextFormField(
        obscureText: true,
        controller: _passwordFieldController,
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Please enter password";
          }
          if (value.trim().length < 6) {
            return "The Password must be at least 6 characters";
          }
          return null;
        },
        onSaved: (value) => _password = value.trim(),
        decoration: InputDecoration(
          icon: const Icon(Icons.lock),
          labelText: "Password",
        ),
      ),
    );

    final loginButton = Padding(
        padding: EdgeInsets.only(top: 26.0),
        child: RaisedButton(
            onPressed: _onLoginButtonTap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text("Login")));
    Widget _authenticatingWidget = Padding(
        padding: EdgeInsets.only(top: 26.0),
        child: RaisedButton(
            onPressed: _authenticate,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text(authString, style: TextStyle(color: Colors.black),)));

    var loaderView = new Container(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor)));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: _saving
              ? loaderView
              : Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                      email,
                      password,
                      loginButton,
                      //_authenticatingWidget
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future _onLoginButtonTap() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _saving = true;
      });
      new RestServerApi()
          .login("", _email, _password)
          .then((ServerResponse<LoginResponse> result) {
        if (result != null) {
          _onLoginResultSuccess(result.Data);
        } else {
          showAlertDialog("", result.Message);
        }
        setState(() {
          _saving = false;
        });
      }).catchError((onError) {
        setState(() {
          _saving = false;
        });
        showAlertDialog("Login Failed", "Login Failed.Please try again");
      });
    }
  }

  void _onLoginResultSuccess(LoginResponse response) {
    new SessionManager().saveLoginSession(response).then((bool done) async {
      await SessionManager().saveLoginUser(true);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      authString = message;
    });
  }
}
