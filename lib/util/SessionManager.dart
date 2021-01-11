import 'dart:async';
import 'package:demo_app/model/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String PREF_KEY_USERID = 'com.demo.pref.PREF_KEY_USERID';
  static const String PREF_KEY_EMAIL = 'com.demo.pref.PREF_KEY_EMAIL5';
  static const String PREF_KEY_FNAME = 'com.demo.pref.PREF_KEY_FNAME';
  static const String PREF_KEY_LNAME = 'com.demo.pref.PREF_KEY_LNAME';
  static const String PREF_KEY_LOGIN_USER = 'com.demo.pref.PREF_KEY_LOGIN_USER';

  static final SessionManager _singleton = new SessionManager._internal();

  Future<SharedPreferences> _mPref;

  factory SessionManager() {
    return _singleton;
  }

  SessionManager._internal() {
    _initPref();
  }

  _initPref() {
    _mPref = SharedPreferences.getInstance();
  }

  Future<bool> saveLoginSession(LoginResponse user) async {
    final SharedPreferences _prefs = await _mPref;
    _prefs.setString(PREF_KEY_FNAME, user.firstName);
    _prefs.setString(PREF_KEY_LNAME, user.lastName);
    return _prefs.setString(PREF_KEY_EMAIL, user.email);
  }

  Future<bool> logoutUser() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.clear();
  }

  Future<String> getLoginUserFirstName() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getString(PREF_KEY_FNAME);
  }

  Future<String> getLoginUserLastName() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getString(PREF_KEY_LNAME);
  }

  Future<String> getLoginUserEmail() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getString(PREF_KEY_EMAIL);
  }

  Future<bool> setLoginUserEmail(String email) async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.setString(PREF_KEY_EMAIL, email);
  }

  Future<void> saveLoginUser(bool done) async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.setBool(PREF_KEY_LOGIN_USER, done);
  }

  Future<bool> isLoginUser() async {
    final SharedPreferences _prefs = await _mPref;
    return _prefs.getBool(PREF_KEY_LOGIN_USER) ?? false;
  }
}
