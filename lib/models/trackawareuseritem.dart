

class TrackawareUserItem {
  String firstName;
  String lastName;
  String userName;
  Party party;
  String username;

  TrackawareUserItem(
      {this.firstName,
      this.lastName,
      this.userName,
      this.party,
      this.username});

  TrackawareUserItem.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    party = json['party'] != null ? new Party.fromJson(json['party']) : null;
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['userName'] = this.userName;
    if (this.party != null) {
      data['party'] = this.party.toJson();
    }
    data['username'] = this.username;
    return data;
  }
}


class Party {
  String code;
  String name;
  String typeOne;

  Party({this.code, this.name, this.typeOne});

  Party.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    typeOne = json['typeOne'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['typeOne'] = this.typeOne;
    return data;
  }
}