import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/new logic/sign.dart';
import 'package:trackaware_lite/new logic/takepicture.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';

class DeliveryTabWidget extends StatefulWidget {
  final DeliveryApiRepository deliveryApiRepository;

  DeliveryTabWidget({@required this.deliveryApiRepository}) : assert(deliveryApiRepository != null);
  @override
  _DeliveryState createState() => new _DeliveryState(key: key, deliveryApiRepository: deliveryApiRepository);
}

class _DeliveryState extends State<DeliveryTabWidget> {
  final DeliveryApiRepository deliveryApiRepository;
  final Key key;
  _DeliveryState({@required this.deliveryApiRepository, @required this.key});

  CameraController controller;
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

  @override
  void initState() {
    super.initState();
    if (globals.deliveryList.length == 0) {
      globals.selectedCard = 0;
    }
  }

  Widget getDeliveryList() {
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
                              globals.deliveryList.removeAt(position);
                            });
                          },
                        )
                      ],
                      child: GestureDetector(
                        onTap: () async {
                          getLocation();

                          setState(() {
                            globals.deliveryList[position].destination = globals.currentLocation.thoroughfare;
                            if (globals.deliveryList[position].isSelected != true) {
                              setState(() {
                                globals.deliveryList[position].isSelected = true;
                                globals.selectedCard = globals.selectedCard + 1;
                              });
                            } else {
                              setState(() {
                                globals.deliveryList[position].isSelected = false;
                                globals.selectedCard = globals.selectedCard - 1;
                                globals.deliveryList[position].destination = 'UNKNOWN';
                              });
                            }
                          });
                        },
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
                                    colors: globals.deliveryList[position].isSelected == true
                                        ? [Color(0xff9cffff).withOpacity(.5), Color(0xcb81adff).withOpacity(.5)]
                                        : [Color(0xff9cffff).withOpacity(.2), Color(0xcb81adff).withOpacity(.2)],
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
                                                    " " + (position + 1).toString() + " ",
                                                    style: TextStyle(color: Color(0xe2131313).withOpacity(.2), fontSize: 11.0, fontWeight: FontWeight.bold),
                                                  )),
                                            )),
                                        Container(
                                            padding: EdgeInsets.fromLTRB(16.0, 0, 0.0, 0.0),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                  padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0),
                                                  child: Text(globals.deliveryList[position].orderNumber,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.right,
                                                      style: const TextStyle(color: const Color(0xffffffff), fontSize: 16.0))),
                                            )),
                                      ]),
                                      Icon(
                                        Entypo.dot_single,
                                        color: globals.deliveryList[position].isSelected == true ? Color(0xff62ff56) : Color(0xfff1f8ff).withOpacity(.5),
                                        size: 32,
                                      )
                                    ],
                                  ),
                                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.fromLTRB(20, 0, 24.0, 0.0),
                                        child: Align(
                                            alignment: Alignment.topRight, child: Text(" Note ", textAlign: TextAlign.right, style: const TextStyle(color: const Color(0xffd5c9ff), fontSize: 11.0)))),
                                    SizedBox(
                                      width: horizontalPixel * 1,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          width: horizontalPixel * 63,
                                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: Text(globals.deliveryList[position].partNumber != null ? globals.deliveryList[position].partNumber : "N/A",
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
                                              Text(globals.deliveryList[position].location != null ? globals.deliveryList[position].location : "",
                                                  style: TextStyle(color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400, fontSize: 11.0))
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text("Destination", style: const TextStyle(color: const Color(0xff241835), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0)),
                                              globals.deliveryList[position].destination == null
                                                  ? Text("")
                                                  : Text(globals.deliveryList[position].destination,
                                                      style: TextStyle(color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400, fontSize: 11.0))
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              )),
                        ),
                      ),
                    );
                  },
                  itemCount: globals.deliveryList != null ? globals.deliveryList.length : 0,
                ))));
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
              height: verticalPixel * 65,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Total: ' + globals.deliveryList.length.toString(),
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  Text(
                                    'Selected: ' + globals.selectedCard.toString(),
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          globals.deliveryList.isNotEmpty
                              ? getDeliveryList()
                              : Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(16, 0.0, 16, 0),
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
                                                          'No item available for ',
                                                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                                                        ),
                                                        Text(
                                                          'delivery',
                                                          style: TextStyle(fontSize: 20.0, color: Color(0xff9969ff)),
                                                        ),
                                                      ],
                                                    ))
                                              ]))))),
                        ],
                      )),
                ),
              )),
          Container(
            height: verticalPixel * 6,
            child: Visibility(
              visible: globals.selectedCard >= 1,
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
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: Text(
                              'Sign & Release',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Sign()),
                              ).then((value) => setState(() {}));
                            });
                          },
                        ),
                      ),
                    ),
                    ButtonTheme(
                      height: verticalPixel * 5,
                      minWidth: horizontalPixel * 10,
                      child: RaisedButton(
                        color: Color(0xffff2954),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Text(
                            'Delivery',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TakePictureScreen(camera: globals.cameras)),
                          ).then((value) => setState(() {}));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
