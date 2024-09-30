import 'package:exo4/model/UserAccount.dart';
import 'package:exo4/services/CarAPI.dart';
import 'package:http/http.dart' as http;

class UserAccountRoutes extends CarAPI {
  static const userAcoountRoute = '/useraccount';

  Future insert(UserAccount userAccount) async {
    final response = await http.post(
      Uri.http(apiServer, userAcoountRoute),
      body: userAccount.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to insert user account');
    }
  }

}