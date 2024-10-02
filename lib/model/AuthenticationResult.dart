

class AuthenticationResult {
  final String displayname;
  final String login;
  final String token;

  AuthenticationResult({
    required this.displayname,
    required this.login,
    required this.token,
  });

  toMap() {
    return {
      'displayname': displayname,
      'login': login,
      'token': token,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return AuthenticationResult(
      displayname: map['displayname'],
      login: map['login'],
      token: map['token'],
    );
  }
}