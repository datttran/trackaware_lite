import 'package:trackaware_lite/globals.dart' as globals;
class TransactionRequest {
  String handHeldId;
  String user;
  String location;
  String status;
  int id;
  List<Packages> packages;

  TransactionRequest(
      {this.handHeldId,
      this.user,
      this.location,
      this.status,
      this.id,
      this.packages});

  TransactionRequest.fromJson(Map<String, dynamic> json) {
    handHeldId = json['HandHeldId'];
    user = json['User'];
    location = json['Location'];
    status = json['Status'];
    id = json['id'];
    if (json['Packages'] != null) {
      packages = new List<Packages>();
      json['Packages'].forEach((v) {
        packages.add(new Packages.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HandHeldId'] = this.handHeldId.toString();
    data['User'] = this.user;
    data['Location'] = this.location.toString();
    data['Status'] = this.status;
    data["id"] = this.id;
    if (this.packages != null) {
      data['Packages'] = this.packages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  String deliveryLocation;
  String orderNum;
  String containerNum;
  String labelNum;
  String priority;
  String quantity;
  String scanTime;
  String receiverBadgeId;
  String receivedBy;
  String item;
  String status;
  int isPart;

  Packages(
      {this.deliveryLocation,
      this.orderNum,
      this.containerNum,
      this.labelNum,
      this.priority,
      this.quantity,
      this.scanTime,
      this.receiverBadgeId,
      this.receivedBy,
      this.item,
      this.status,
      this.isPart});

  Packages.fromJson(Map<String, dynamic> json) {
    deliveryLocation = json['DeliveryLocation'];
    orderNum = json['OrderNum'];
    containerNum = json['ContainerNum'];
    labelNum = json['LabelNum'];
    priority = json['Priority'];
    quantity = json['Quantity'];
    scanTime = json['ScanTime'];
    receiverBadgeId = json['ReceiverBadgeId'];
    receivedBy = json['ReceivedBy'];
    item = json['Item'];
    status = json['Status'];
    isPart = json["is_part"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeliveryLocation'] = this.deliveryLocation;
    data['OrderNum'] = this.orderNum;
    data['Reference'] = this.containerNum.isEmpty ? this.orderNum : this.containerNum;
/*    if (this.status == 'tender'){
      data['LabelNum'] = this.orderNum + ":" + this.item;
    }
    else{

      data['LabelNum'] = 'something_else'; // use to be this.labelNum
    }*/
    data['LabelNum'] = this.labelNum == null ? this.orderNum +":" +this.item : this.labelNum;

    data['Priority'] = this.priority;
    data['Quantity'] = this.quantity;
    data['ScanTime'] = this.scanTime;
    data['ReceiverBadgeId'] = this.receiverBadgeId;
    data['ReceivedBy'] = this.receivedBy;
    data['Item'] = this.item;
    data['Status'] = this.status;
    if(globals.useToolNumber == true){
      data["TagType"] = "7";
    }
    else if ( this.item.contains('KIT')){
      data["TagType"] = "6";

    }
    else{
      data["TagType"] = "5";
    }
    data['is_part'] = this.isPart;
    return data;
  }
}
