import 'dart:convert';

PickUpExternal pickUpExternalFromJson(String str) =>
    PickUpExternal.fromJson(json.decode(str));

String pickUpExternalToJson(PickUpExternal data) => json.encode(data.toJson());

class PickUpExternal {
  int id;
  String pickUpSite;
  String deliverySite;
  String trackingNumber;
//  String orderNumber;// added
 // String partNumber;// added
  int scanTime;
  int isSynced;
  int isScanned;
  int isPart;
  int isDelivered;

  PickUpExternal(
      {this.id,
      this.pickUpSite,
      this.deliverySite,
      this.trackingNumber,
    //  this.orderNumber, // added
    //  this.partNumber, //added
      this.scanTime,
      this.isSynced,
      this.isScanned,
      this.isPart,
      this.isDelivered});

  factory PickUpExternal.fromJson(Map<String, dynamic> json) => PickUpExternal(
      id: json["id"],
      pickUpSite: json["pick_up_site"],
      deliverySite: json["delivery_site"],
      trackingNumber: json["tracking_number"],
   //   orderNumber: json["order_number"],//added
   //   partNumber: json["part_number"],//added
      scanTime: json["scan_time"],
      isSynced: json["is_synced"],
      isScanned: json["is_scanned"],
      isPart: json["is_part"],
      isDelivered: json["is_delivered"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "pick_up_site": pickUpSite,
        "delivery_site": deliverySite,
        "tracking_number": trackingNumber,
    //    "order_number": orderNumber,//added
   //     "part_number": partNumber,//added
        "scan_time": scanTime,
        "is_synced": isSynced,
        "is_scanned": isScanned,
        "is_part": isPart,
        "is_delivered": isDelivered
      };
}
