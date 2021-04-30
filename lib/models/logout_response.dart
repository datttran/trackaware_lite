class LogoutResponse {
  String message;
  String accessToken;
  String username;
  String role;

  LogoutResponse({this.message, this.accessToken, this.username, this.role});

  LogoutResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accessToken = json['access_token'];
    username = json['username'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    data['username'] = this.username;
    data['role'] = this.role;
    return data;
  }
}