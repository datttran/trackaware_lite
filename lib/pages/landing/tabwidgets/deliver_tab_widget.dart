import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/delivery_bloc.dart';
import 'package:trackaware_lite/pages/delivery/tab/delivery_page.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:trackaware_lite/globals.dart' as globals;
class DeliveryTabWidget extends StatefulWidget {
  final DeliveryApiRepository deliveryApiRepository;

  DeliveryTabWidget({@required this.deliveryApiRepository})
      : assert(deliveryApiRepository != null);
  @override
  _DeliveryState createState() => new _DeliveryState(
      key: key, deliveryApiRepository: deliveryApiRepository);
}

class _DeliveryState extends State<DeliveryTabWidget> {
  final DeliveryApiRepository deliveryApiRepository;
  final Key key;
  _DeliveryState({@required this.deliveryApiRepository, @required this.key});
  


  Widget getDeliveryList() {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0.0, 16, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  shrinkWrap: false,
                  itemBuilder: (context, position) {
                    return Slidable(
                      actionPane: SlidableScrollActionPane(),
                      actions: [
                        IconSlideAction(
                          caption: 'Remove',
                          color: Colors.transparent,
                          icon: Icons.delete_forever,
                          onTap: (){

                            setState(() {

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
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Container(
                            height: 100,
                            decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [
                                    Color(0xffe4fff5).withOpacity(.5),
                                    Color(0xcbc7f4ff).withOpacity(.3)],
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
                                                    color:  Color(0xe2d1fffd).withOpacity(.2)  ,
                                                    borderRadius: new BorderRadius.only(
                                                        topLeft: const Radius.circular(16.0),
                                                        topRight: const Radius.circular(16.0),
                                                        bottomLeft: const Radius.circular(16.0),
                                                        bottomRight: const Radius.circular(16.0))),
                                                child: Text(
                                                  ' N O ',
                                                  style: TextStyle(color: Color(0xe2131313).withOpacity(.2), fontSize: 11.0,  fontWeight: FontWeight.bold),
                                                )),)),
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
                                    Icon(Entypo.dot_single, color: Color(0xfff1f8ff).withOpacity(.5),size: 32,)
                                  ],
                                ),
                                Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.fromLTRB(20, 0, 24.0, 0.0),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text("  Part ", textAlign: TextAlign.right, style: const TextStyle(color: const Color(0xffd5c9ff), fontSize: 11.0)))),
                                  /*Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(5, 0, 20.0, 0),
                                        child: Text(globals.deliveryList[position].partNumber,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(color: const Color(0xffd5c9ff), fontStyle: FontStyle.normal, fontSize: 11.0))),
                                  )*/
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
                                            Text("Location",
                                                style: const TextStyle(
                                                    color: const Color(0xff241835), fontWeight: FontWeight.w400,   fontStyle: FontStyle.normal, fontSize: 13.0)),
                                            Text(globals.deliveryList[position].location != null ? globals.deliveryList[position].location : "",
                                                style:  TextStyle(
                                                    color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400,  fontSize: 11.0))
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text("Destination",
                                                style: const TextStyle(
                                                    color: const Color(0xff241835), fontWeight: FontWeight.w400,   fontStyle: FontStyle.normal, fontSize: 13.0)),
                                            globals.deliveryList[position].destination == null
                                                ? Text("")
                                                : Text(globals.deliveryList[position].destination,
                                                style:  TextStyle(
                                                    color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400,   fontSize: 11.0))
                                          ],
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      ),
                    );
                  },
                  itemCount: globals.deliveryList != null ? globals.deliveryList.length : 0,
                ))));
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            height: verticalPixel*68,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                        globals.deliveryList.isNotEmpty
                            ? getDeliveryList() :
                        Expanded(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonTheme(
              height: verticalPixel*2,
              minWidth: horizontalPixel*10,
              child: RaisedButton(
                color: Color(0xff2C2C34),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ) ,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onPressed: (){


                },
              ),
            ),
            ButtonTheme(
              height: verticalPixel*2,
              minWidth: horizontalPixel*10,
              child: RaisedButton(
                color: Color(0xff2C2C34),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ) ,

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
                onPressed: (){


                },
              ),
            ),

          ],
        )
      ],
    );
  }
}
