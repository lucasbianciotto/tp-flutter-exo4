class UserAccount {
  final String displayname;
  final String login;
  final String? password;

  UserAccount({
    required this.displayname,
    required this.login,
    this.password,
  });

  toMap() {
    return {
      'displayname': displayname,
      'login': login,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return UserAccount(
      displayname: map['displayname'],
      login: map['login'],
      password: map['password'],
    );
  }




}