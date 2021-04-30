class ServerConfigResponse {
  int id;
  String baseUrl;
  String userName;
  String password;

  ServerConfigResponse({this.id, this.baseUrl, this.userName, this.password});

  ServerConfigResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseUrl = json['base_url'];
    userName = json['user_name'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['base_url'] = this.baseUrl;
    data['user_name'] = this.userName;
    data['password'] = this.password;
    return data;
  }
}
