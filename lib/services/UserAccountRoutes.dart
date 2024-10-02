import 'dart:convert';

import 'package:exo4/model/AuthenticationResult.dart';
import 'package:exo4/model/UserAccount.dart';
import 'package:exo4/services/CarAPI.dart';
import 'package:http/http.dart' as http;

class UserAccountRoutes extends CarAPI {
  static const userAccountRoute = '/useraccount';
  static const userAuthRoute = '$userAccountRoute/authenticate';

  Future insert(UserAccount userAccount) async {
    final response = await http.post(
      Uri.http(CarAPI.apiServer, userAccountRoute),
      body: userAccount.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to insert user account');
    }
  }

  get(String login) async {
    final response = await http.get(
      Uri.http(CarAPI.apiServer, '$userAccountRoute/$login'),
    );

    if (response.statusCode == 200) {
      return false;
    }

    return true;
  }

  Future authenticate(String login, String password) async {
    final response = await http.post(
      Uri.http(CarAPI.apiServer, userAuthRoute),
      body: {
        'login': login,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return AuthenticationResult.fromMap(result);
    }

    return null;
  }

  static Future<String> refreshToken(String token) async {
    final response = await http.get(
      Uri.http(CarAPI.apiServer, '$userAccountRoute/refreshtoken'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return result['token'];
    }

    throw Exception('Failed to refresh token');
  }

}