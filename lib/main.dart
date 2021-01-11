import 'package:demo_app/util/SessionManager.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _isAuthenticated = await new SessionManager().isLoginUser();

  runApp(MyApplication(_isAuthenticated));
}
