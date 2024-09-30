class UserAccount {
  final String displayName;
  final String login;
  final String? password;

  UserAccount({
    required this.displayName,
    required this.login,
    this.password,
  });

  toMap() {
    return {
      'displayName': displayName,
      'login': login,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return UserAccount(
      displayName: map['displayName'],
      login: map['login'],
    );
  }




}