import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;
import 'package:trackaware_lite/blocs/pickup_tab_bloc.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/pages/pickup/add_popup.dart';

var loca = new location.Location();
bool _serviceEnabled;
location.PermissionStatus _permissionGranted;
location.LocationData _locationData;

getLocation() async {
  _serviceEnabled = await loca.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await loca.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await loca.hasPermission();
  if (_permissionGranted == location.PermissionStatus.denied) {
    _permissionGranted = await loca.requestPermission();
    if (_permissionGranted != location.PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await loca.getLocation();
  List<Placemark> placeMarks = await placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
  globals.currentLocation = placeMarks[0];
  print(placeMarks);
}

class PickUpTabWidget extends StatefulWidget {
  final TabController tabController;
  PickUpTabWidget({this.tabController});
  @override
  PickUpTab createState() => PickUpTab();
}

PickUpTabBloc _pickUpTabBloc;
int pickUpPartCount = -1;
int pickUpExternalCount = -1;

class PickUpTab extends State<PickUpTabWidget> {
  String _scanBarcode = 'N/A';
  String location = 'Home';
  String destination = 'Destination';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver('#ff6666', 'Cancel', true, ScanMode.BARCODE).listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;

      if (_scanBarcode != '-1') {
        createTicket();
      }
    });
  }

  void createTicket() {
    PickUpPart pickupItem = new PickUpPart();
    pickupItem.orderNumber = _scanBarcode.toString();
    pickupItem.location = location;
    pickupItem.destination = destination;

    globals.pickupList.add(pickupItem);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  bool showPerformance = false;
  onSettingCallback() {
    setState(() {
      showPerformance = !showPerformance;
    });
  }

  Widget getPickUpList() {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0.0, 0, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.fromLTRB(0, verticalPixel * 2, 0, 0),
                  shrinkWrap: false,
                  itemBuilder: (context, position) {
                    return Slidable(
                      actionPane: SlidableScrollActionPane(),
                      actions: [
                        IconSlideAction(
                          caption: 'Remove',
                          color: Colors.transparent,
                          icon: Icons.delete_forever,
                          onTap: () {
                            setState(() {
                              globals.pickupList.removeAt(position);
                            });
                          },
                        )
                      ],
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, verticalPixel * 2),
                        child: Container(
                            height: 100,
                            decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [Color(0xff9cffff).withOpacity(.5), Color(0xcb81adff).withOpacity(.5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.fromLTRB(20, 12.0, 0.0, 0.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                                height: 17,
                                                padding: EdgeInsets.fromLTRB(5.0, 2, 5.0, 0),
                                                margin: EdgeInsets.only(right: 5),
                                                decoration: new BoxDecoration(
                                                    color: Color(0xe2d1fffd).withOpacity(.2),
                                                    borderRadius: new BorderRadius.only(
                                                        topLeft: const Radius.circular(16.0),
                                                        topRight: const Radius.circular(16.0),
                                                        bottomLeft: const Radius.circular(16.0),
                                                        bottomRight: const Radius.circular(16.0))),
                                                child: Text(
                                                  ' N O ',
                                                  style: TextStyle(color: Color(0xe2131313).withOpacity(.2), fontSize: 11.0, fontWeight: FontWeight.bold),
                                                )),
                                          )),
                                      Container(
                                          padding: EdgeInsets.fromLTRB(16.0, 0, 0.0, 0.0),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0),
                                                child: Text(globals.pickupList[position].orderNumber,
                                                    maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right, style: const TextStyle(color: const Color(0xffffffff), fontSize: 16.0))),
                                          )),
                                    ]),
                                    /*Icon(
                                      Entypo.dot_single,
                                      color: Color(0xfff1f8ff).withOpacity(.5),
                                      size: 32,
                                    )*/
                                  ],
                                ),
                                Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.fromLTRB(20, 0, 24.0, 0.0),
                                      child: Align(
                                          alignment: Alignment.topRight, child: Text(" Note ", textAlign: TextAlign.right, style: const TextStyle(color: const Color(0xffffffff), fontSize: 11.0)))),
                                  SizedBox(
                                    width: horizontalPixel * 1,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        width: horizontalPixel * 63,
                                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Text(globals.pickupList[position].partNumber != null ? globals.pickupList[position].partNumber : "N/A",
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(color: const Color(0xffe0dee7), fontStyle: FontStyle.normal, fontSize: 11.0))),
                                  )
                                ]),
                                Divider(
                                  color: const Color(0xfffff2f2),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text("Location", style: const TextStyle(color: const Color(0xff241835), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0)),
                                            Text(globals.pickupList[position].location != null ? globals.pickupList[position].location : "",
                                                style: TextStyle(color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400, fontSize: 11.0))
                                          ],
                                        ),
                                        Icon(
                                          Icons.sync_alt,
                                          size: verticalPixel * 2,
                                          color: Colors.white70.withOpacity(.3),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text("Destination", style: const TextStyle(color: const Color(0xff241835), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0)),
                                            globals.pickupList[position].destination == null
                                                ? Text("")
                                                : Text(globals.pickupList[position].destination,
                                                    style: TextStyle(color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400, fontSize: 11.0))
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      ),
                    );
                  },
                  itemCount: globals.pickupList != null ? globals.pickupList.length : 0,
                ))));
  }

  @override
  void dispose() {
    _pickUpTabBloc = null;
    pickUpPartCount = -1;
    pickUpExternalCount = -1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale('en', 'US'),
      //You have to set this parameters to your locale
      textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
      backgroundColor: Color(0x99000000),
      borderRadius: BorderRadius.circular(5.0),
      textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
      toastAnimation: StyledToastAnimation.size,
      reverseAnimation: StyledToastAnimation.size,
      startOffset: Offset(0.0, -1.0),
      reverseEndOffset: Offset(0.0, -1.0),
      duration: Duration(seconds: 4),
      animDuration: Duration(seconds: 1),
      alignment: Alignment.center,
      toastPositions: StyledToastPosition.center,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
      dismissOtherOnShow: true,
      fullWidth: false,
      isHideKeyboard: false,
      isIgnoring: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: verticalPixel * 72,
              margin: EdgeInsets.symmetric(horizontal: horizontalPixel * 3.5, vertical: verticalPixel * 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff2C2C34),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Column(
                        children: [
                          Container(
                            height: verticalPixel * 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xff171721),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: verticalPixel * .2),
                              child: Text(
                                '   Total: ' + globals.pickupList.length.toString(),
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ),
                          ),
                          globals.pickupList.isNotEmpty
                              ? getPickUpList()
                              : Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0.0, 0, 0),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Material(
                                              color: Colors.transparent,
                                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Scan to add ',
                                                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                        ),
                                                        /*Text(
                                                      'pick up ',
                                                      style: TextStyle(fontSize: 20.0, color: Color(0xff9969ff)),
                                                    ),*/
                                                        Text(
                                                          'item',
                                                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                        ),
                                                      ],
                                                    ))
                                              ]))))),
                        ],
                      )),
                ),
              )),
          Visibility(
            visible: globals.popup == 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPixel * 3.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ButtonTheme(
                      height: verticalPixel * 5,
                      minWidth: horizontalPixel * 10,
                      child: RaisedButton(
                        color: Color(0xff2C2C34),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff171721)),
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          getLocation();

                          setState(() {
                            globals.popup = 1;
                          });
                          showCupertinoModalPopup(context: context, builder: (BuildContext context) => Pop(0)).then((value) {
                            setState(() {
                              globals.popup = 0;
                            });
                          });
                          print(globals.pickupList.toString());
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: globals.pickupList.length > 0,
                    child: ButtonTheme(
                      height: verticalPixel * 5.2,
                      minWidth: horizontalPixel * 10,
                      child: RaisedButton(
                        color: Color(0xffff2a46),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(00.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () {
                          try {
                            setState(() {
                              globals.pickupList.forEach((element) {
                                globals.deliveryList.add(element);
                              });

                              globals.pickupList = [];
                              showToast('Success!', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);
                            });
                          } catch (e) {
                            showToast('Fail!', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ButtonTheme(
                      height: verticalPixel * 5,
                      minWidth: horizontalPixel * 10,
                      child: RaisedButton(
                        color: Color(0xff2C2C34),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff171721)),
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Text(
                            'Scan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () {
                          scanBarcodeNormal();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
