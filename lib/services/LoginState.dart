import 'package:exo4/model/UserAccount.dart';
import 'package:flutter/material.dart';

class LoginState extends ChangeNotifier {
  UserAccount? _user;
  String? _token;

  connected() => _user != null;

  get user => _user;

  setToken(String token) {
    _token = token;
    notifyListeners();
  }

  getToken() => _token;

  disconnect() {
    _user = null;
    _token = null;
    notifyListeners();
  }

}