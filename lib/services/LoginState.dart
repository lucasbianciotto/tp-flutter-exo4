import 'package:exo4/model/UserAccount.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState extends ChangeNotifier {
  UserAccount? _user;
  String? _token;

  LoginState() {
    _loadFromPreferences();
  }

  bool connected() => _user != null;

  UserAccount? get user => _user;

  String? getToken() => _token;

  Future<void> setUser(UserAccount user) async {
    _user = user;
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> disconnect() async {
    _user = null;
    _token = null;
    await _clearPreferences();
    notifyListeners();
  }

  Future<void> _loadFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? login = prefs.getString('login');
    final String? displayname = prefs.getString('displayname');
    final String? token = prefs.getString('token');

    if (login != null && displayname != null && token != null) {
      _user = UserAccount(login: login, displayname: displayname);
      _token = token;
      notifyListeners();
    }
  }

  Future<void> _saveToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_user != null && _token != null) {
      await prefs.setString('login', _user!.login);
      await prefs.setString('displayname', _user!.displayname);
      await prefs.setString('token', _token!);
    }
  }

  Future<void> _clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('login');
    await prefs.remove('displayname');
    await prefs.remove('token');
  }
}
