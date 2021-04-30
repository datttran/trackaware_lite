// To parse this JSON data, do
//
//     final tenderExternal = tenderExternalFromJson(jsonString);

import 'dart:convert';

TenderExternal tenderExternalFromJson(String str) =>
    TenderExternal.fromJson(json.decode(str));

String tenderExternalToJson(TenderExternal data) => json.encode(data.toJson());

class TenderExternal {
  int id;
  String priority;
  int quantity;
  String location;
  String destination;
  String orderNumber;
  String refNumber;
  String partNumber;
  String trackingNumber;
  int keepScannedValues;
  int scanTime;
  int isSynced;
  int isScanned;

  TenderExternal(
      {this.id,
      this.priority,
      this.quantity,
      this.location,
      this.destination,
      this.orderNumber,
      this.refNumber,
      this.partNumber,
      this.trackingNumber,
      this.keepScannedValues,
      this.scanTime,
      this.isSynced,
      this.isScanned});

  factory TenderExternal.fromJson(Map<String, dynamic> json) => TenderExternal(
      id: json["id"],
      priority: json["priority"],
      quantity: json["quantity"],
      location: json["location"],
      destination: json["dest_location"],
      orderNumber: json["order_number"],
      refNumber: json["ref_number"],
      partNumber: json["part_number"],
      trackingNumber: json["tracking_number"],
      keepScannedValues: json["keep_scanned_values"],
      scanTime: json["scan_time"],
      isSynced: json["is_synced"],
      isScanned: json["is_scanned"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "priority": priority,
        "quantity": quantity,
        "location": location,
        "dest_location": destination,
        "order_number": orderNumber,
        "ref_number": refNumber,
        "part_number": partNumber,
        "tracking_number": trackingNumber,
        "keep_scanned_values": keepScannedValues,
        "scan_time": scanTime,
        "is_synced": isSynced,
        "is_scanned": isScanned
      };
}
