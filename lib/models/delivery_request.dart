class DeliveryRequest {
  String handHeldId;
  String user;
  String location;
  String status;
  String scanTime;
  int id;

  DeliveryRequest(
      {this.handHeldId, this.user, this.location, this.status,this.id, this.scanTime});

  DeliveryRequest.fromJson(Map<String, dynamic> json) {
    handHeldId = json['HandHeldId'];
    user = json['User'];
    location = json['Location'];
    status = json['Status'];
    scanTime = json['ScanTime'];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HandHeldId'] = this.handHeldId;
    data['User'] = this.user;
    data['Location'] = this.location;
    data['Status'] = this.status;
    data['ScanTime'] = this.scanTime;
    data["id"]=this.id;
    return data;
  }
}