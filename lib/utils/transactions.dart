import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/arrive_db.dart';
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/depart_db.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/utils/strings.dart';

_sendToServer(TransactionRequest transactionRequest) async {
  try {
    final response = await http.post(
      Uri.parse(globals.baseUrl + '/transaction/'),
      headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic cmtoYW5kaGVsZGFwaTppMjExVTI7'},
      body: jsonEncode(transactionRequest.toJson()),
    );
    print(response.statusCode);
    print(transactionRequest.toString());
  } catch (E) {
    print('ERROR' + E);
  }
}

Packages getPackageFromPickUpPart(PickUpPart pickUpPart) {
  Packages packages = Packages();
  packages.deliveryLocation = 'N/A';
  packages.item = "N/A";
  packages.labelNum = pickUpPart.orderNumber; //tracking number
  packages.quantity = "";
  packages.orderNum = "ReferenceNumber";
  packages.priority = "";
  packages.receivedBy = pickUpPart.receivedBy != null ? pickUpPart.receivedBy : 'Unknown user';
  packages.receiverBadgeId = "";
  packages.status = "";
  packages.scanTime = "";
  packages.containerNum = "";

  return packages;
}

Packages getPackageFromPickUpExternal(PickUpExternal pickUpExternal) {
  Packages packages = Packages();
  packages.deliveryLocation = pickUpExternal.deliverySite;
  packages.item = "THIS IS ITEM FROM GET PACKAGE";
  packages.labelNum = pickUpExternal.trackingNumber;
  packages.quantity = "";

  packages.priority = "";
  packages.receivedBy = "";
  packages.receiverBadgeId = "";
  packages.status = "";
  packages.scanTime = pickUpExternal.scanTime.toString();
  packages.isPart = pickUpExternal.isPart;
  packages.containerNum = globals.barCode;
  return packages;
}

Packages getPackage(TenderExternal tenderExternal) {
  Packages packages = Packages();
  packages.deliveryLocation = tenderExternal.destination;
  if (tenderExternal.partNumber == null || tenderExternal.partNumber.isEmpty)
    packages.item = "LAM_01";
  else
    packages.item = tenderExternal.partNumber;
  packages.labelNum = tenderExternal.trackingNumber;
  packages.quantity = tenderExternal.quantity.toString();
  packages.orderNum = tenderExternal.orderNumber;
  packages.priority = tenderExternal.priority;
  packages.receivedBy = "";
  packages.receiverBadgeId = "";
  packages.status = "";
  packages.scanTime = tenderExternal.scanTime.toString();
  packages.containerNum = tenderExternal.refNumber;
  return packages;
}

Packages getPackageFromTenderPart(TenderParts tenderParts) {
  Packages packages = Packages();
  packages.deliveryLocation = tenderParts.destination.toString();
  if (tenderParts.partNumber == null || tenderParts.partNumber.isEmpty)
    packages.item = "LAM_01";
  else
    packages.item = tenderParts.partNumber.toString();
  packages.containerNum = tenderParts.toolNumber;
  packages.quantity = tenderParts.quantity.toString();
  packages.orderNum = tenderParts.orderNumber;
  packages.priority = tenderParts.priority.toString();
  packages.receivedBy = "".toString();
  packages.receiverBadgeId = "".toString();
  packages.status = "".toString();
  packages.scanTime = tenderParts.scanTime.toString();
  //packages.containerNum = "";
  return packages;
}

String getLocationRequest(LocationData currentLocation, String deviceIdValue, String userName) {
  return "[" +
      "{" +
      "Deviceid='" +
      deviceIdValue +
      "',Username:" +
      "'" +
      userName +
      "'" +
      ", Latitude: '" +
      currentLocation.latitude.toString() +
      "', Longitude='" +
      currentLocation.longitude.toString() +
      "',Altitude='" +
      currentLocation.altitude.toString() +
      "',Sourcetime='" +
      new DateTime.now().millisecondsSinceEpoch.toString() +
      "'}" +
      "]";
}

TransactionRequest generateTransactionForDeliveryFromPickupExternal(PickUpExternal pickUpExternal, String deviceIdValue, String userName) {
  TransactionRequest transactionRequest = TransactionRequest();

  transactionRequest.handHeldId = deviceIdValue;
  transactionRequest.id = pickUpExternal.id;
  transactionRequest.location = pickUpExternal.pickUpSite;
  transactionRequest.status = Strings.DELIVERY;
  transactionRequest.user = userName;
  transactionRequest.packages = [getPackageFromPickUpExternal(pickUpExternal)];
  _sendToServer(transactionRequest);
  return transactionRequest;
}

TransactionRequest generateTransactionFromPickupExternal(PickUpExternal pickUpExternal, String deviceIdValue, String userName) {
  TransactionRequest transactionRequest = TransactionRequest();

  transactionRequest.handHeldId = deviceIdValue;
  transactionRequest.id = pickUpExternal.id;
  transactionRequest.location = pickUpExternal.pickUpSite;
  transactionRequest.status = Strings.PICKUP;
  transactionRequest.user = userName;
  transactionRequest.packages = [getPackageFromPickUpExternal(pickUpExternal)];
  return transactionRequest;
}

TransactionRequest generateTransactionFromPickupPart(PickUpPart pickUpPart, String deviceIdValue, String userName) {
  TransactionRequest transactionRequest = TransactionRequest();

  transactionRequest.handHeldId = deviceIdValue;
  transactionRequest.id = pickUpPart.id;
  transactionRequest.location = pickUpPart.location;
  transactionRequest.status = Strings.PICKUP;
  transactionRequest.user = userName;
  transactionRequest.packages = [getPackageFromPickUpPart(pickUpPart)];
  _sendToServer(transactionRequest);
  return transactionRequest;
}

TransactionRequest generateTransactionListFromTenderParts(TenderParts tenderParts, String deviceIdValue, String userName) {
  TransactionRequest transactionRequest = TransactionRequest();

  transactionRequest.handHeldId = deviceIdValue;
  transactionRequest.id = tenderParts.id;
  transactionRequest.location = tenderParts.location;
  transactionRequest.status = Strings.TENDER;
  transactionRequest.user = userName;
  // transactionRequest.user = "rr0055256";
  transactionRequest.packages = [getPackageFromTenderPart(tenderParts)];
  return transactionRequest;
}

TransactionRequest generateTransactionList(TenderExternal tenderExternal, String deviceIdValue, String userName) {
  TransactionRequest transactionRequest = TransactionRequest();

  transactionRequest.handHeldId = deviceIdValue;
  transactionRequest.id = tenderExternal.id;
  transactionRequest.location = tenderExternal.location;
  transactionRequest.status = Strings.TENDER;
  transactionRequest.user = userName;
  // transactionRequest.user = "rr0055256";
  transactionRequest.packages = [getPackage(tenderExternal)];
  return transactionRequest;
}

DeliveryRequest generateDeliveryList(Arrive arrive, String deviceIdValue, String userName) {
  DeliveryRequest deliveryRequest = new DeliveryRequest();
  deliveryRequest.handHeldId = deviceIdValue;
  deliveryRequest.id = arrive.id;
  deliveryRequest.user = userName;
  deliveryRequest.location = arrive.location;
  deliveryRequest.status = Strings.ARRIVE_LOWERCASE;
  deliveryRequest.scanTime = arrive.scanTime.toString();
  return deliveryRequest;
}

DeliveryRequest generateDeliveryListFromDepartItem(Depart depart, String deviceIdValue, String userName) {
  DeliveryRequest deliveryRequest = new DeliveryRequest();
  deliveryRequest.handHeldId = deviceIdValue;
  deliveryRequest.id = depart.id;
  deliveryRequest.user = userName;
  deliveryRequest.location = depart.location;
  deliveryRequest.status = Strings.DEPART_LOWERCASE;
  deliveryRequest.scanTime = depart.scanTime.toString();
  return deliveryRequest;
}
