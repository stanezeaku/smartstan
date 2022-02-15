class User {
  String user;
  String password;

  User({required this.user, required this.password});

  static User fromDB(String dbuser) {
    return User(user: dbuser.split(':')[0], password: dbuser.split(':')[1]);
  }
}
