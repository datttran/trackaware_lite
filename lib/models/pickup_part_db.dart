// To parse this JSON data, do
//
//     final tenderExternal = tenderExternalFromJson(jsonString);

import 'dart:convert';

PickUpPart pickUpPartFromJson(String str) =>
    PickUpPart.fromJson(json.decode(str));

String pickUpPartToJson(PickUpPart data) => json.encode(data.toJson());

//todo - add is_scanned item and verify scan
class PickUpPart {
  int id;
  String location;
  String destination;
  String orderNumber;
  String partNumber;
  int scanTime;
  int isSynced;
  int isScanned;
  int keepScannedValues;
  int isDelivered;
  bool isSelected;

  PickUpPart(
      {this.id,
      this.location,
      this.destination,
      this.orderNumber,
      this.partNumber,
      this.scanTime,
      this.isSynced,
      this.isScanned,
      this.isDelivered,
      this.keepScannedValues,
      this.isSelected});
  @override
  String toString() {
    return toJson().toString();
  }

  factory PickUpPart.fromJson(Map<String, dynamic> json) => PickUpPart(
      id: json["id"],
      location: json["location"],
      destination: json["dest_location"],
      orderNumber: json["order_number"],
      partNumber: json["part_number"],
      scanTime: json["scan_time"],
      isSynced: json["is_synced"],
      isScanned: json["is_scanned"],
      isDelivered: json["is_delivered"],
      keepScannedValues: json["keep_scanned_values"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "dest_location": destination,
        "order_number": orderNumber,
        "part_number": partNumber,
        "scan_time": scanTime,
        "is_synced": isSynced,
        "is_scanned": isScanned,
        "is_delivered": isDelivered,
        "keep_scanned_values": keepScannedValues,
        
      };
}
