import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/pickup_part_db.dart';

class Pop extends StatefulWidget {
  final int showID;
  static String id = 'pop_up';

  Pop(this.showID);
  @override
  _PopState createState() => _PopState();
}

class _PopState extends State<Pop> {
  var left = Colors.black;
  var right = Colors.white;

  int shareValue;
  colorCheck() {
    if (shareValue == 0) {
      userPages = setColor(Colors.black, Colors.white);
    } else {
      userPages = setColor(
        Colors.white,
        Colors.black,
      );
    }

    return userPages;
  }

  Map userPages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    shareValue = widget.showID;
    userPages = colorCheck();

    _pageController = PageController(initialPage: shareValue);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void _onButtonPress(val) {
    _pageController.animateToPage(val, duration: Duration(milliseconds: 550), curve: Curves.decelerate);
    setState(() {
      if (val == 0) {
        userPages = setColor(Colors.black, Colors.white);
      } else {
        userPages = setColor(Colors.white, Colors.black);
      }
    });
  }

  void onPageChange(val) {}

  void createTicket(barcode, note, {destination = "N/A"}) {
    PickUpPart pickupItem = new PickUpPart();
    pickupItem.partNumber = note;
    pickupItem.orderNumber = barcode.toString();
    pickupItem.location = globals.currentLocation.thoroughfare;
    pickupItem.destination = destination;

    globals.pickupList.add(pickupItem);
  }

  PageController _pageController;
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
        children: <Widget>[
          SizedBox(
            height: verticalPixel * 9,
          ),
          Container(
            height: verticalPixel * 85,
            width: horizontalPixel * 93.5,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    width: horizontalPixel * 70,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: <Widget>[
                            CupertinoSlidingSegmentedControl(
                              padding: EdgeInsets.symmetric(horizontal: verticalPixel),
                              onValueChanged: (int val) {
                                shareValue = val;
                                _onButtonPress(val);
                              },
                              children: userPages,
                              groupValue: shareValue,
                            ),
                            buildPageView(),

                            //loginBoxes[shareValue],
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPageView() {
    return Container(
      color: Colors.redAccent.withOpacity(0),
      height: verticalPixel * 65,
      child: PageView(
        onPageChanged: (int val) {
          shareValue = val;
          _onButtonPress(val);
        },
        controller: _pageController,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPixel * 3.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: horizontalPixel * 2,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                          ),
                          Text(
                            globals.currentLocation != null
                                ? "   " +
                                    globals.currentLocation.street +
                                    ', ' +
                                    globals.currentLocation.locality +
                                    ', ' +
                                    globals.currentLocation.administrativeArea +
                                    ' ' +
                                    globals.currentLocation.postalCode
                                : 'UNKNOWN',
                            style: TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: verticalPixel * 3),
                      TextField(
                        style: TextStyle(color: Color(0xffc5c5cb)),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          globals.value = value;
                          //Do something with the user input.
                        },
                        decoration: InputDecoration(
                          hintText: 'Tap to manually enter barcode',
                          hintStyle: TextStyle(color: Colors.white70.withOpacity(.2)),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff8091ff), width: .5),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4d5cde), width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: verticalPixel * 3,
                      ),
                      TextField(
                        textInputAction: TextInputAction.done,
                        minLines: 7,
                        maxLines: 10,
                        style: TextStyle(color: Color(0xffc5c5cb)),
                        onChanged: (value) {
                          globals.note = value;
                          //Do something with the user input.
                        },
                        decoration: InputDecoration(
                          hintText: 'Note',
                          hintStyle: TextStyle(color: Colors.white70.withOpacity(.2)),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff8091ff), width: .5),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4d5cde), width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: verticalPixel * 3),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: MaterialButton(
                        elevation: 0,
                        //color: Color(0xff7663E9),
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          if (globals.value != null) {
                            createTicket(globals.value, globals.note);
                            globals.value = null;
                            globals.note = null;
                            Navigator.pop(context);
                          } else {
                            showToast('Please enter barcode!', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);
                          }
                        },
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff68b3ec), Color(0xff8543de)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: verticalPixel * 1, horizontal: verticalPixel * 5.4),
                            child: FittedBox(
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.white, fontSize: verticalPixel * 2, fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
          ConstrainedBox(constraints: BoxConstraints.expand(), child: null)
        ],
      ),
    );
  } // return PageView
}

setColor(left, right) {
  return {
    0: Text(
      'Auto',
      style: TextStyle(color: left),
    ),
    1: Text(
      'Manual',
      style: TextStyle(color: right),
    )
  };
}

var left = Colors.black;
var right = Colors.white;
