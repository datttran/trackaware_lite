class LoginResponse {
  String message;
  String accessToken;

  LoginResponse({this.message, this.accessToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    return data;
  }
}