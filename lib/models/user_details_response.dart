class UserDetailsResponse {
  String firstName;
  String lastName;
  String username;
  String email;

  UserDetailsResponse(
      {this.firstName, this.lastName, this.username, this.email});

  UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['username'] = this.username;
    data['email'] = this.email;
    return data;
  }
}