import 'package:demo_app/DashBoardScreen.dart';
import 'package:demo_app/LoginPage.dart';
import 'package:flutter/material.dart';

///
/// theme for android
///
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.green[600],
  buttonColor: Colors.green[500],
  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
  accentColor: Colors.lightBlue,
  primaryColorBrightness: Brightness.dark,
  primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
  primaryIconTheme: IconThemeData.fallback().copyWith(color: Colors.grey[800]),
);

class MyApplication extends StatelessWidget {
  final bool _isAuthenticated;

  MyApplication(this._isAuthenticated);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Demo App',

        ///debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // When we navigate to the "/" route, build the FirstScreen Widget after checing the user is logged in or not
          '/': (context) => _isAuthenticated ? DashBoardScreen() : LoginPage(),
          '/home': (context) => DashBoardScreen(),
          // When we navigate to the "/login" route, build the LoginPage Widget
          '/login': (context) => LoginPage()
        });
  }
}
