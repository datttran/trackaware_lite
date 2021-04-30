// To parse this JSON data, do
//
//     final tenderExternal = tenderExternalFromJson(jsonString);

import 'dart:convert';

TenderParts tenderPartsFromJson(String str) =>
    TenderParts.fromJson(json.decode(str));

String tenderPartsToJson(TenderParts data) => json.encode(data.toJson());

class TenderParts {
  int id;
  String priority;
  int quantity;
  String location;
  String destination;
  String orderNumber;
  String partNumber;
  String toolNumber;
  int keepScannedValues;
  int scanTime;
  int isSynced;
  int isScanned;

  TenderParts(
      {this.id,
      this.priority,
      this.quantity,
      this.location,
      this.destination,
      this.orderNumber,
      this.partNumber,
      this.toolNumber,
      this.keepScannedValues,
      this.scanTime,
      this.isSynced,
      this.isScanned});

  @override
  String toString() {
    return toJson().toString();
  }

  factory TenderParts.fromJson(Map<String, dynamic> json) => TenderParts(
      id: json["id"],
      priority: json["priority"],
      quantity: json["quantity"],
      location: json["location"],
      destination: json["dest_location"],
      orderNumber: json["order_number"],
      partNumber: json["part_number"],
      toolNumber: json["tool_number"],
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
        "part_number": partNumber,
        "tool_number": toolNumber,
        "keep_scanned_values": keepScannedValues,
        "scan_time": scanTime,
        "is_synced": isSynced,
        "is_scanned": isScanned
      };


}
