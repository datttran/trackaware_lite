class User {
  String userName;
  String token;
  String password;
  int rememberMe;
  int logout;

  User({this.userName, this.token});

  User.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    token = json['token'];
    password = json['password'];
    rememberMe = json['remember_me'];
    logout = json['logout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['token'] = this.token;
    data['password'] = this.password;
    data['remember_me'] = this.rememberMe;
    data['logout'] = this.logout;
    return data;
  }
}
