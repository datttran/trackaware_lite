import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trackaware_lite/blocs/list_external_tender_bloc.dart';
import 'package:trackaware_lite/events/list_tender_external_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/states/list_external_tender_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

List<TenderExternal> tenderListItems = List<TenderExternal>();
ListExternalTenderBloc listExternalTenderBloc;
List<TransactionRequest> _transactionRequestItems = List<TransactionRequest>();
var _deviceIdValue;
String _userName;
int transactionCount = 0;
bool _isLoading = false;

class TenderExternalPage extends StatefulWidget {
  @override
  _TenderExternalState createState() => new _TenderExternalState();
}

class _TenderExternalState extends State<TenderExternalPage> {
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
                          globals.tenderExternal = tenderListItems[position];
                          var result = await Navigator.of(context).pushNamed('/NewTenderExternalScreen');
                          if (result?.toString()?.isNotEmpty == true) {
                            listExternalTenderBloc.dispatch(ListExternalTenderItemsEvent());
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                              height: 160,
                              decoration: new BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      HexColor(ColorStrings.tenderPartsGradientColorFirst),
                                      HexColor(ColorStrings.tenderPartsGradientColorSecond),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.fromLTRB(20, 12.0, 0.0, 0.0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "# " + tenderListItems[position].orderNumber,
                                            style: TextStyle(fontSize: 16.0, fontFamily: 'SourceSansPro', fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                                          ))),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(20, 12.0, 0.0, 0.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                                            decoration: new BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: new BorderRadius.only(
                                                    topLeft: const Radius.circular(16.0),
                                                    topRight: const Radius.circular(16.0),
                                                    bottomLeft: const Radius.circular(16.0),
                                                    bottomRight: const Radius.circular(16.0))),
                                            child: Text(
                                              tenderListItems[position].priority,
                                              style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal),
                                            )),
                                      )),
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.fromLTRB(18, 0.0, 18.0, 0.0),
                                    child: Divider(color: HexColor(ColorStrings.divider)),
                                  )),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(18.0, 8.0, 18.0, 14.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                "Location",
                                                style: TextStyle(color: HexColor(ColorStrings.tenderHeading), fontSize: 13.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal),
                                              ),
                                              Text(
                                                tenderListItems[position].location,
                                                style: TextStyle(color: HexColor(ColorStrings.tenderValues), fontSize: 13.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text("Qty", style: TextStyle(color: HexColor(ColorStrings.tenderHeading), fontSize: 13.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal)),
                                              Text(
                                                tenderListItems[position].quantity.toString(),
                                                style: TextStyle(color: HexColor(ColorStrings.tenderValues), fontSize: 13.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text("Destination",
                                                  style: TextStyle(color: HexColor(ColorStrings.tenderHeading), fontSize: 13.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal)),
                                              Text(tenderListItems[position].destination.toString(),
                                                  style: TextStyle(color: HexColor(ColorStrings.tenderValues), fontSize: 13.0, fontFamily: 'SourceSansPro', fontStyle: FontStyle.normal))
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              )),
                        ));
                  },
                  itemCount: tenderListItems.isNotEmpty ? tenderListItems.length : 0,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    listExternalTenderBloc = BlocProvider.of<ListExternalTenderBloc>(context);
    listExternalTenderBloc.dispatch(ListExternalTenderItemsEvent());

    Widget getScaffold() {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, "back");
              },
              child: Image.asset("images/ic_back.png"),
            ),
            middle: Text(Strings.tenderExternal),
          ),
          child: Container(
            color: HexColor(ColorStrings.boxBackground).withAlpha(30),
            child: Stack(children: [
              Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        var result = await Navigator.of(context).pushNamed('/NewTenderExternalScreen');

                        if (result?.toString()?.isNotEmpty == true) {
                          listExternalTenderBloc.dispatch(ListExternalTenderItemsEvent());
                        }
                      },
                      child: Padding(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0.0),
                            padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(8.0), topRight: const Radius.circular(8.0), bottomLeft: const Radius.circular(8.0), bottomRight: const Radius.circular(8.0))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20.0, 0, 16.0, 0),
                                  child: Image.asset('images/ic_add.png'),
                                ),
                                Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      Strings.ADD_NEW,
                                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                                    ))
                              ],
                            )),
                        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                      )),
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
                                        SvgPicture.asset(
                                          "assets/ic_box.svg",
                                          semanticsLabel: "empty icon",
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                            child: Text(
                                              Strings.NO_TENDER_ITEMS,
                                              style: TextStyle(fontSize: 20.0, backgroundColor: Colors.transparent),
                                            ))
                                      ]))))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: Visibility(
                              visible: tenderListItems.length > 0,
                              child: ButtonTheme(
                                  minWidth: double.infinity,
                                  child: RaisedButton(
                                      elevation: 8.0,
                                      clipBehavior: Clip.antiAlias,
                                      padding: EdgeInsets.all(16),
                                      child: Text(Strings.SEND,
                                          style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0),
                                          textAlign: TextAlign.center),
                                      onPressed: () {
                                        listExternalTenderBloc.dispatch(FetchUserName());
                                      },
                                      color: const Color(0xff424e53))))))
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
          ));
    }

    _generateTransactionList(TenderExternal tenderExternal) {
      if (tenderExternal.isSynced == 0) {
        TransactionRequest transactionRequest = TransactionRequest();

        transactionRequest.handHeldId = _deviceIdValue;
        transactionRequest.id = tenderExternal.id;
        transactionRequest.location = tenderExternal.location;
        transactionRequest.status = Strings.TENDER;
        transactionRequest.user = _userName;
        // transactionRequest.user = "rr0055256";
        transactionRequest.packages = [getPackage(tenderExternal)];
        _transactionRequestItems.add(transactionRequest);
      }
    }

    _generateTransactionRequest() {
      tenderListItems.forEach((_generateTransactionList));
    }

    Widget getCupertinoScaffold(BuildContext context, ListExternalTenderState state) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context, "back");
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<ListExternalTenderBloc, ListExternalTenderState>(
        listener: (context, state) {
          if (state is ExternalTenderListFetchSuccess) {
            tenderListItems.clear();
            tenderListItems.addAll(state.tenderExternalResponse.reversed);
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
                listExternalTenderBloc.dispatch(SendExternalButtonClick(_transactionRequestItems[i], _deviceIdValue, _userName));
              }
            } else {
              print("No transactions to be synced");
            }
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            listExternalTenderBloc.dispatch(FetchDeviceId());
          }

          if (state is ScanSuccess) {
            var scanCount = state.scanCount;
            showAlertDialog(context, scanCount == 1 ? "$scanCount item picked up." : "$scanCount items picked up.", null);
            listExternalTenderBloc.dispatch(ListExternalTenderItemsEvent());
          }

          if (state is TenderExternalSaved) {
            if (transactionCount != 0 && transactionCount == _transactionRequestItems.length) {
              transactionCount = 0;
              _isLoading = false;
              print(state.message);
              listExternalTenderBloc.dispatch(ListExternalTenderItemsEvent());
            } else {
              _isLoading = false;
            }
          }

          if (state is TenderExternalFailure) {
            _isLoading = false;
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
}
