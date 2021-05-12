import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trackaware_lite/blocs/list_pickup_bloc.dart';
import 'package:trackaware_lite/events/list_pickup_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';
import 'package:trackaware_lite/states/list_pickup_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

List<PickUpExternal> pickUpItems = List<PickUpExternal>();
var listPickUpBloc;
var _deviceIdValue;
String _userName;
int transactionCount = 0;
List<TransactionRequest> _transactionRequestItems = List<TransactionRequest>();
bool _isLoading = false;

class PickUpExternalPage extends StatefulWidget {
  final PickUpApiRepository pickUpApiRepository;

  PickUpExternalPage({Key key, @required this.pickUpApiRepository})
      : assert(pickUpApiRepository != null),
        super(key: key);

  @override
  _PickUpExternalState createState() => new _PickUpExternalState(pickUpApiRepository);
}

class _PickUpExternalState extends State<PickUpExternalPage> {
  final PickUpApiRepository pickUpApiRepository;

  _PickUpExternalState(this.pickUpApiRepository);

  Widget getPickUpList() {
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
                          globals.selectedPickUpExternal = pickUpItems[position];
                          var result = await Navigator.of(context).pushNamed('/NewPickUpExternalScreen');
                          if (result?.toString()?.isNotEmpty == true) {
                            listPickUpBloc.dispatch(ListExternalPickUpItemsEvent());
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                              height: 130,
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
                                          child: Text("# Tracking Number",
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(color: const Color(0xff767272), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0)))),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(20.0, 2.0, 0.0, 0.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(0.0, 2.0, 20.0, 7.0),
                                            child: Text(pickUpItems[position]?.trackingNumber == null ? "" : pickUpItems[position]?.trackingNumber,
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(color: const Color(0xff000000), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 18.0))),
                                      )),
                                  Expanded(
                                      child: Container(
                                          margin: EdgeInsets.fromLTRB(18, 0.0, 18.0, 0.0),
                                          child: Divider(
                                            color: const Color(0xff484343),
                                          ))),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 14.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text("Pick Up Site",
                                                  style: const TextStyle(
                                                      color: const Color(0xff767272), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 13.0)),
                                              Text(pickUpItems[position].pickUpSite != null ? pickUpItems[position].pickUpSite : "",
                                                  style: const TextStyle(
                                                      color: const Color(0xff202020), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 13.0))
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text("Delivery Site",
                                                  style: const TextStyle(
                                                      color: const Color(0xff767272), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 13.0)),
                                              Text(pickUpItems[position].deliverySite != null ? pickUpItems[position].deliverySite : "",
                                                  style: const TextStyle(
                                                      color: const Color(0xff202020), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 13.0))
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              )),
                        ));
                  },
                  itemCount: pickUpItems != null ? pickUpItems.length : 0,
                ))));
  }

  Widget getScaffold() {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          // We're specifying a back label here because the previous page is a
          // Material page. CupertinoPageRoutes could auto-populate these back
          // labels.
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, "back");
            },
            child: Image.asset("images/ic_back.png"),
          ),

          middle: Text(Strings.PICKUP_EXTERNAL),
        ),
        child: Container(
          color: HexColor(ColorStrings.boxBackground).withAlpha(30),
          child: Stack(
            children: [
              Column(children: <Widget>[
                GestureDetector(
                    onTap: () async {
                      var result = await Navigator.of(context).pushNamed('/NewPickUpExternalScreen');
                      if (result?.toString()?.isNotEmpty == true) {
                        listPickUpBloc.dispatch(ListExternalPickUpItemsEvent());
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
                pickUpItems.isNotEmpty
                    ? getPickUpList()
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
                                            Strings.NO_PICKUP_ITEMS,
                                            style: TextStyle(fontSize: 20.0, backgroundColor: Colors.transparent),
                                          ))
                                    ]))))),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Visibility(
                            visible: pickUpItems.length > 0,
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
                                      listPickUpBloc.dispatch(FetchUserName());
                                    },
                                    color: const Color(0xff424e53)))))),
              ]),
              Align(
                child: _isLoading
                    ? CupertinoActivityIndicator(
                        animating: true,
                        radius: 20.0,
                      )
                    : Text(""),
                alignment: AlignmentDirectional.center,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    listPickUpBloc = BlocProvider.of<ListPickUpBloc>(context);
    listPickUpBloc.dispatch(ListExternalPickUpItemsEvent());
    Widget getCupertinoScaffold(BuildContext context, ListPickUpState state) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context, "back");
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    _generateTransactionList(PickUpExternal pickUpExternal) {
      if (pickUpExternal.isSynced == 0) {
        TransactionRequest transactionRequest = TransactionRequest();

        transactionRequest.handHeldId = _deviceIdValue;
        transactionRequest.id = pickUpExternal.id;
        transactionRequest.location = pickUpExternal.deliverySite;
        transactionRequest.status = Strings.PICKUP;
        transactionRequest.user = _userName;
        transactionRequest.packages = [getPackageFromPickUpExternal(pickUpExternal)];
        _transactionRequestItems.add(transactionRequest);
      }
    }

    _generateTransactionRequest() {
      pickUpItems.forEach((_generateTransactionList));
    }

    return BlocListener<ListPickUpBloc, ListPickUpState>(
        listener: (context, state) {
          if (state is ExternalPickUpListFetchSuccess) {
            pickUpItems.clear();
            pickUpItems.addAll(state.pickUpExternalResponse.reversed);
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            listPickUpBloc.dispatch(FetchDeviceId());
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceIdValue = state.deviceId;
            _generateTransactionRequest();
            if (_transactionRequestItems.isNotEmpty) {
              for (var i = 0; i < _transactionRequestItems.length; i++) {
                transactionCount += 1;
                listPickUpBloc.dispatch(SendExternalButtonClick(_transactionRequestItems[i], _deviceIdValue, _userName));
              }
            } else {
              print("No transactions to be synced");
            }
          }

          if (state is TransactionLoading) {
            _isLoading = true;
          }

          if (state is PickUpExternalSaved) {
            if (transactionCount != 0 && transactionCount == _transactionRequestItems.length) {
              transactionCount = 0;
              _isLoading = false;
              print(state.message);
              listPickUpBloc.dispatch(ListExternalPickUpItemsEvent());
            } else {
              _isLoading = false;
            }
          }

          if (state is PickUpPartsFailure) {
            _isLoading = false;
          }
        },
        child: BlocBuilder<ListPickUpBloc, ListPickUpState>(
            bloc: listPickUpBloc,
            builder: (
              BuildContext context,
              ListPickUpState state,
            ) {
              return getCupertinoScaffold(context, state);
            }));
  }
}
