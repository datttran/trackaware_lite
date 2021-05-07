library trackaware_lite.globals;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';

import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/utils/strings.dart';

import 'package:flutter/material.dart';
bool isDriverMode = true;
bool useToolNumber = false;
String tenderProductionPartsDispName = Strings.TENDER_PRODUCTION_PARTS;
String tenderExternalPackagesDispName = Strings.TENDER_EXTERNAL_PACKAGES;
String pickUpProductionPartsDispName = Strings.PICKUP_PRODUCTION_PARTS;
String pickUpExternalPackagesDispName = Strings.PICKUP_EXTERNAL_PACKAGES;
String departDispName = Strings.departTitle;
String arriveDispName = Strings.arriveTitle;

String selectedKey = "";
String selectedName = "";

int selectedTabIndex = 0;

String selectedLoc = "";
bool showNextButton = false;
bool refreshDelivery = false;

String baseUrl = "http://13.57.192.146/trackaware/handheldapi";
//String baseUrl = "http://54.241.28.203/trackaware/handheldapi";
//String baseUrl = "http://50.18.108.22/trackaware/handheldapi";  // na2

String serverUserName = "rkhandheldapi";
//String serverPassword = "TrackAware11";
String serverPassword = "i211U2;";

String tabScanPosName = "";
String scanOption = "";
String pickScanOption = "";

String orderNumber = "";
String partNumber = "";
String refNumber = "";
String toolNumber = "";
String trackingNumber = "";

String navFrom = "";
String barCode = "";
String scannedCode = 'Empty';


bool isPickUpOnTender = false;

PickUpPart selectedPickUpPart;
PickUpExternal selectedPickUpExternal;

TenderParts tenderParts;
TenderExternal tenderExternal;

int popup = 0;
//List
List pickupList = [];
List deliveryList = [];
Color themeBackground = Color(0xfff0ccff);


