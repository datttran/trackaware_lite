class LocationResponse {
  int id;
  String code;
  String description;
  String loc;

  LocationResponse({this.code, this.description});

  LocationResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    id = json['id'];
    loc = json['loc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    data['id'] = this.id;
    data['loc'] = this.loc;
    return data;
  }
}

class LocationApiResponse {
  String message;

  LocationApiResponse({this.message});

  LocationApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
