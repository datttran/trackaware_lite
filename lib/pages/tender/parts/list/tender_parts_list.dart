import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'package:trackaware_lite/events/profile_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/blocs/list_external_tender_bloc.dart';
import 'package:trackaware_lite/events/list_tender_external_event.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/pages/tender/parts/list/tender_parts.dart';
import 'package:trackaware_lite/states/list_external_tender_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:trackaware_lite/database/database.dart';

List<TenderParts> tenderListItems = List<TenderParts>();

var listExternalTenderBloc;
List<TransactionRequest> _transactionRequestItems = List<TransactionRequest>();
var _deviceIdValue;
String _userName;
int transactionCount = 0;
bool _isLoading = false;

class TenderPartsPage extends StatefulWidget {
  @override
  _TenderPartsState createState() => new _TenderPartsState();
}

class _TenderPartsState extends State<TenderPartsPage> {
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState removeState = ButtonState.idle;


  Widget getTenderList() {
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
                    return GestureDetector(
                        onTap: () async {
                          globals.tenderParts = tenderListItems[position];
                          var result = await Navigator.of(context).pushNamed('/NewTenderPartsScreen');
                          if (result?.toString()?.isNotEmpty == true) {
                            listExternalTenderBloc.dispatch(ListTenderPartItemsEvent());
                          }
                        },
                        child: Column(
                          children: [
                            Card(
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
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.fromLTRB(20, 12.0, 0.0, 0.0),
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    children: [
                                                      Container(
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
                                                          )),
                                                      Text(' '+
                                                        tenderListItems[position].orderNumber,
                                                        style: TextStyle(fontSize: 15.0 , fontStyle: FontStyle.normal,
                                                            color: tenderListItems[position].priority == 'P1' ? Color(0xffff3c62)
                                                                : Color(0xff0d031d).withOpacity(.5)),
                                                      ),
                                                    ],
                                                  ))),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(20, 12.0, 15, 0.0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  height: 17,
                                                    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                                    decoration: new BoxDecoration(
                                                        color: tenderListItems[position].priority == 'P1' ? Color(0xffff1442).withOpacity(.8) :
                                                        Color(0xffffdc65).withOpacity(.8),
                                                        borderRadius: new BorderRadius.only(
                                                            topLeft: const Radius.circular(16.0),
                                                            topRight: const Radius.circular(16.0),
                                                            bottomLeft: const Radius.circular(16.0),
                                                            bottomRight: const Radius.circular(16.0))),
                                                    child: Text(
                                                      tenderListItems[position].priority,
                                                      style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal),
                                                    )),
                                              )),
                                        ],
                                      ),

                                      Container(
                                        margin: EdgeInsets.fromLTRB(0,0, 0, 0),
                                        child: Divider(
                                          thickness: .2,
                                          color: tenderListItems[position].priority == 'P1' ? Color(0xffff1442).withOpacity(.8) :
                                        Color(0xffffdc65).withOpacity(.8),),
                                      ),
                                      Container(
                                          padding: EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Location",
                                                    style: TextStyle(color:Color(0xff241835), fontSize: 13.0,   fontStyle: FontStyle.normal),
                                                  ),
                                                  Text(
                                                    tenderListItems[position].location,
                                                    style: TextStyle(color: Color(0xff0e0935).withOpacity(.5), fontSize: 11.0,   fontStyle: FontStyle.normal),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text("Quantity", style: TextStyle(color: Color(0xff241835), fontSize: 13.0,   fontStyle: FontStyle.normal)),
                                                  Text(
                                                    tenderListItems[position].quantity.toString(),
                                                    style: TextStyle(color: Color(0xff0e0935).withOpacity(.5), fontSize: 11.0,  fontStyle: FontStyle.normal),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text("Destination",
                                                      style: TextStyle(color: Color(0xff241835), fontSize: 13.0,   fontStyle: FontStyle.normal)),
                                                  Text(tenderListItems[position].destination.toString(),
                                                      style: TextStyle(color: Color(0xff0e0935).withOpacity(.5), fontSize: 11.0,  fontStyle: FontStyle.normal))
                                                ],
                                              ),
                                            ],
                                          ))
                                    ],
                                  )),
                            ),

                          ],
                        ));
                  },
                  itemCount: tenderListItems.isNotEmpty ? tenderListItems.length : 0,
                ))));
  }

  Widget getScaffold() {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          // swiping in right direction

          Navigator.pop(context, 'back');
        }
        else if (details.delta.dx < 0){
          Navigator.of(context).pushNamed('/PickUpPartsScreen');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(

              image: AssetImage('images/bg9.png'),

              //4.7.10 look nice
              fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          /*navigationBar: CupertinoNavigationBar(
              // We're specifying a back label here because the previous page is a
              // Material page. CupertinoPageRoutes could auto-populate these back
              // labels.
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context, "back");
                },
                child: Image.asset("images/ic_back.png",),
              ),

              middle: Text(Strings.TENDER_PARTS),
            ),*/
          body: Container(
            color: HexColor(ColorStrings.boxBackground).withAlpha(30),
            child: Stack(children: [
              Column(
                children: <Widget>[
                  /*GestureDetector(
                        onTap: () {
                          _navigateToCreateTenderPart();
                        },
                        child: Padding(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
                              padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                              width: double.infinity,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(8.0),
                                      topRight: const Radius.circular(8.0),
                                      bottomLeft: const Radius.circular(8.0),
                                      bottomRight: const Radius.circular(8.0))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20.0, 0, 16.0, 0),
                                    child: Column(
                                      children: [

                                        Icon(AntDesign.plus, ),
                                        SizedBox(height: 5,)
                                      ],
                                    ),
                                  ),
                                  Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        Strings.ADD_NEW,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 22.0),
                                      )),

                                ],
                              )),
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        )),
                    GestureDetector(
                        onTap: () {
                          if(_transactionRequestItems.length > 0 ){
                            _transactionRequestItems.forEach((element) {
                              print(element.toString());
                            });
                          }
                          //_transactionRequestItems.clear();

                        },
                        child: Padding(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0.0),
                              padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                              width: double.infinity,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(8.0),
                                      topRight: const Radius.circular(8.0),
                                      bottomLeft: const Radius.circular(8.0),
                                      bottomRight: const Radius.circular(8.0))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(20.0, 0, 16.0, 0),
                                    child: Icon(Icons.add_sharp),
                                  ),
                                  Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        'Print tender List',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18.0),
                                      )),

                                ],
                              )),
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        )),*/
                  tenderListItems.isNotEmpty
                      ? getTenderList()
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
                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'No ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      backgroundColor:
                                                      Colors.transparent),
                                                ),
                                                Text(
                                                  'tender ',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Color(0xfffff199)),
                                                ),
                                                Text(
                                                  'items found!',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                      fontSize: 20.0,
                                                      backgroundColor:
                                                      Colors.transparent),
                                                ),
                                              ],
                                            ))
                                      ]))))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 10),
                          child: Visibility(
                              visible: tenderListItems.length > 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: ProgressButton.icon(
                                      maxWidth: 130.0,
                                      height: 30.0,
                                      iconedButtons: {
                                        ButtonState.idle: IconedButton(
                                          color: Color(0xffac00ff),
                                          icon: Icon(
                                            AntDesign.bells,
                                            color: Colors.white,
                                            size: 0,
                                          ),
                                          text: "Clear",
                                        ),
                                        ButtonState.loading: IconedButton(
                                            text: "Loading",

                                            color: Color(0xff9d13ff)),
                                        ButtonState.fail: IconedButton(text: "Failed", icon: Icon(Icons.cancel, color: Colors.white), color: Colors.red.shade300),
                                        ButtonState.success: IconedButton(
                                            text: "Success",
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            color: Color(0xff4CD964))
                                      },
                                      onPressed: () async {



                                        switch (removeState) {

                                          case ButtonState.idle:
                                            removeState = ButtonState.loading;

                                            Future.delayed(Duration(seconds: 1), () {



                                              setState(() {




                                                removeState = ButtonState.success;
                                              });
                                            });

                                            break;
                                          case ButtonState.loading:
                                            break;
                                          case ButtonState.success:
                                            removeState = ButtonState.idle;

                                            break;
                                          case ButtonState.fail:
                                            removeState = ButtonState.idle;
                                            break;
                                        }
                                        setState(() {
                                          removeState = removeState;
                                        });

                                        Future.delayed(Duration(seconds: 3), () {
                                          setState(() {
                                            DBProvider.db.removeTenderPart();
                                            removeState = ButtonState.idle;
                                          });

                                        });




                                      },
                                      state: removeState,
                                      minWidth: 100.0,
                                    ),
                                  ),
                                  SizedBox(width: 30,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: ProgressButton.icon(
                                      maxWidth: 130.0,
                                      height: 30.0,
                                      iconedButtons: {
                                        ButtonState.idle: IconedButton(
                                          color: Color(0xffffb07c),
                                          icon: Icon(
                                            AntDesign.bells,
                                            color: Colors.white,
                                            size: 0,
                                          ),
                                          text: "Tender",
                                        ),
                                        ButtonState.loading: IconedButton(
                                            text: "Loading",
                                            icon: Icon(
                                              AntDesign.bells,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            color: Color(0xffff0d92)),
                                        ButtonState.fail: IconedButton(text: "Failed", icon: Icon(Icons.cancel, color: Colors.white), color: Colors.red.shade300),
                                        ButtonState.success: IconedButton(
                                            text: "Success",
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            color: Color(0xff4CD964))
                                      },
                                      onPressed: () {
                                        switch (stateTextWithIcon) {
                                          case ButtonState.idle:
                                            stateTextWithIcon = ButtonState.loading;
                                            Future.delayed(Duration(seconds: 1), () {
                                              listExternalTenderBloc
                                                    .dispatch(FetchUserName());



                                              setState(() {
                                                stateTextWithIcon = ButtonState.success;
                                              });
                                            });

                                            break;
                                          case ButtonState.loading:
                                            break;
                                          case ButtonState.success:
                                            stateTextWithIcon = ButtonState.idle;

                                            break;
                                          case ButtonState.fail:
                                            stateTextWithIcon = ButtonState.idle;
                                            break;
                                        }
                                        setState(() {
                                          stateTextWithIcon = stateTextWithIcon;
                                        });

                                        Future.delayed(Duration(seconds: 3), () {
                                          setState(() {
                                            stateTextWithIcon = ButtonState.idle;
                                          });
                                        });
                                      },
                                      state: stateTextWithIcon,
                                      minWidth: 100.0,
                                    ),
                                  ),

                                ],
                              )))),
                ],
              ),
              Align(
                child: _isLoading
                    ? CupertinoActivityIndicator(
                        animating: true,
                        radius: 20.0,
                      )
                    : Text(""),
                alignment: AlignmentDirectional.center,
              )
            ]),
          ),
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: CircularNotchedRectangle(),
            color: Color(0xff51a0ff).withOpacity(0),
            child: Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Color(0xff6e1bfa).withOpacity(1),
                      Color(0xffC850C0).withOpacity(1),
                      Color(0xffFFCC70).withOpacity(1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0,0.5, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                    },
                    child: Row(
                      children: [
                        Icon( AntDesign.swapleft, color: Colors.white, size: 15,),
                        Text('   Home', style: TextStyle(  fontSize: 16 , color: Colors.white) ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30,),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/PickUpPartsScreen');
                    },
                    child: Row(
                      children: [
                        Text('Pickup   ',style: TextStyle(  fontSize: 16, color: Colors.white )),
                        Icon( AntDesign.swapright, color: Colors.white, size: 15,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffcc7bff).withOpacity(.4),
            hoverElevation: 5,
            onPressed: () {
              _navigateToCreateTenderPart();
            },
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.add,
                size: 40,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [ Color(0xffff2079).withOpacity(0.6),Color(0xff9b56ff) , ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    listExternalTenderBloc = BlocProvider.of<ListExternalTenderBloc>(context);
    listExternalTenderBloc.dispatch(ListTenderPartItemsEvent());
    Widget getCupertinoScaffold(BuildContext context, ListExternalTenderState state) {
      return defaultTargetPlatform == TargetPlatform.android
          ? WillPopScope(
          onWillPop: () {
            Navigator.pop(context, "back");
            return;
          },
          child: getScaffold())
          : getScaffold();
    }















    _sendToServer(TransactionRequest transactionRequest) async {

      try{
        final response = await http.post(
          Uri.parse(globals.baseUrl + '/transaction/'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Basic cmtoYW5kaGVsZGFwaTppMjExVTI7'
          },
          body: jsonEncode(transactionRequest.toJson()),
        );
        print(response.statusCode);
        print(transactionRequest.toString());
      }
      catch(E) {

        print(E);
      }




    }








  _generateTransactionList(TenderParts tenderParts) {

    if (tenderParts.isSynced == 0) {
      TransactionRequest transactionRequest = TransactionRequest();

      transactionRequest.handHeldId = _deviceIdValue;
      transactionRequest.id = tenderParts.id;
      transactionRequest.location = tenderParts.location;
      transactionRequest.status = Strings.TENDER;
      transactionRequest.user = _userName;
      transactionRequest.packages = [getPackageFromTenderPart(tenderParts)];
      _transactionRequestItems.add(transactionRequest);
      _sendToServer(transactionRequest);
    }
  }

  _generateTransactionRequest() {
    tenderListItems.forEach((_generateTransactionList));
  }



    return BlocListener<ListExternalTenderBloc, ListExternalTenderState>(
        listener: (context, state) {
          if (state is TenderPartsListFetchSuccess) {
            tenderListItems.clear();

            tenderListItems.addAll(state.tenderPartsResponse.reversed);
            _transactionRequestItems.clear();
            print('clear all');
          }

          if (state is TransactionLoading) {
            _isLoading = true;
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceIdValue = state.deviceId;
            _generateTransactionRequest();
            if (_transactionRequestItems.isNotEmpty) {
              for (var i = 0; i < _transactionRequestItems.length; i++) {
                transactionCount += 1;
                listExternalTenderBloc.dispatch(SendPartsButtonClick(_transactionRequestItems[i], _deviceIdValue, _userName));
              }
            } else {




              print("No transactions to be synced");


            }
          }

          if (state is TenderPartsSaved) {
            if (transactionCount != 0 && transactionCount == _transactionRequestItems.length) {
              transactionCount = 0;
              _isLoading = false;
              print(state.message);
              listExternalTenderBloc.dispatch(ListTenderPartItemsEvent());
            } else {
              _isLoading = false;
            }
          }

          if (state is TenderPartsFailure) {
            _isLoading = false;
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            listExternalTenderBloc.dispatch(FetchDeviceId());
          }

          if (state is ScanSuccess) {
            var scanCount = state.scanCount;
            showAlertDialog(context, "$scanCount items picked up.", null);
            listExternalTenderBloc.dispatch(ListTenderPartItemsEvent());
          }

          if (state is ScanFailure) {
            showAlertDialog(context, "No items found to be scanned!", null);
          }
        },
        child: BlocBuilder<ListExternalTenderBloc, ListExternalTenderState>(
            bloc: listExternalTenderBloc,
            builder: (
              BuildContext context,
              ListExternalTenderState state,
            ) {
              return getCupertinoScaffold(context, state);
            }));
  }

  void _navigateToCreateTenderPart() async {
    final result = await Navigator.of(context).pushNamed('/NewTenderPartsScreen');
    if (result?.toString()?.isNotEmpty == true) {
      listExternalTenderBloc?.dispatch(ListTenderPartItemsEvent());
    }
  }


}

