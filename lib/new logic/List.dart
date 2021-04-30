
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trackaware_lite/blocs/list_pickup_bloc.dart';
import 'package:trackaware_lite/events/list_pickup_event.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';
import 'package:trackaware_lite/states/list_pickup_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:flutter_icons/flutter_icons.dart';

List<PickUpPart> pickUpItems = List<PickUpPart>();
var listPickUpBloc;
var _deviceIdValue;
String _userName;
int transactionCount = 0;
List<TransactionRequest> _transactionRequestItems = List<TransactionRequest>();
bool _isLoading = false;

class PickUpPartsPage extends StatefulWidget {
  final PickUpApiRepository pickUpApiRepository;

  PickUpPartsPage({Key key, @required this.pickUpApiRepository})
      : assert(pickUpApiRepository != null),
        super(key: key);

  @override
  _PickUpPartsState createState() => new _PickUpPartsState(pickUpApiRepository);
}

class _PickUpPartsState extends State<PickUpPartsPage> {
  final PickUpApiRepository pickUpApiRepository;
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState removeState = ButtonState.idle;

  _PickUpPartsState(this.pickUpApiRepository);
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
                          globals.selectedPickUpPart = pickUpItems[position];
                          var result = await Navigator.of(context).pushNamed('/NewPickUpPartsScreen');
                          if (result?.toString()?.isNotEmpty == true) {
                            listPickUpBloc.dispatch(ListPickUpPartItemsEvent());
                          }
                        },
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
                                                  child: Text(pickUpItems[position].orderNumber,
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
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          padding: EdgeInsets.fromLTRB(5, 0, 20.0, 0),
                                          child: Text(pickUpItems[position].partNumber,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(color: const Color(0xffd5c9ff), fontStyle: FontStyle.normal, fontSize: 11.0))),
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
                                              Text("Location",
                                                  style: const TextStyle(
                                                      color: const Color(0xff241835), fontWeight: FontWeight.w400,   fontStyle: FontStyle.normal, fontSize: 13.0)),
                                              Text(pickUpItems[position].location != null ? pickUpItems[position].location : "",
                                                  style:  TextStyle(
                                                      color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400,  fontSize: 11.0))
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text("Destination",
                                                  style: const TextStyle(
                                                      color: const Color(0xff241835), fontWeight: FontWeight.w400,   fontStyle: FontStyle.normal, fontSize: 13.0)),
                                              pickUpItems[position].destination == null
                                                  ? Text("")
                                                  : Text(pickUpItems[position].destination,
                                                  style:  TextStyle(
                                                      color: Color(0xff0e0935).withOpacity(.5), fontWeight: FontWeight.w400,   fontSize: 11.0))
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

  @override
  Widget build(BuildContext context) {
    listPickUpBloc = BlocProvider.of<ListPickUpBloc>(context);
    listPickUpBloc.dispatch(ListPickUpPartItemsEvent());

    Widget getScaffold() {
      return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            Navigator.pop(context, 'back');
            // swiping in right direction


          }
          else if (details.delta.dx < 0){
            Navigator.of(context).pushNamed('/TenderPartsScreen');
          }
        },

        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg10.png'),

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
                  child: Image.asset("images/ic_back.png"),
                ),

                middle: Text(Strings.PICKUP_PART),
              ),*/
            body: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Column(children: <Widget>[
                    /*GestureDetector(
                          onTap: () async {
                            var result = await Navigator.of(context)
                                .pushNamed('/NewPickUpPartsScreen');
                            if (result?.toString()?.isNotEmpty == true) {
                              listPickUpBloc.dispatch(ListPickUpPartItemsEvent());
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
                                        topLeft: const Radius.circular(8.0),
                                        topRight: const Radius.circular(8.0),
                                        bottomLeft: const Radius.circular(8.0),
                                        bottomRight: const Radius.circular(8.0))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20.0, 0, 16.0, 0),
                                      child: Image.asset('images/ic_add.png'),
                                    ),
                                    Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          Strings.ADD_NEW,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 18.0),
                                        ))
                                  ],
                                )),
                            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                          )),*/

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
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'No ',
                                                style: TextStyle(fontSize: 20.0, backgroundColor: Colors.transparent),
                                              ),
                                              Text(
                                                'pick up ',
                                                style: TextStyle(fontSize: 20.0, color: Color(0xff4c00ff)),
                                              ),
                                              Text(
                                                'items found!',
                                                style: TextStyle(fontSize: 20.0, backgroundColor: Colors.transparent),
                                              ),
                                            ],
                                          ))
                                    ]))))),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 10),
                            child: Visibility(
                                visible: pickUpItems.length > 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: ProgressButton.icon(
                                        iconPadding: 0,
                                        height: 30.0,
                                        maxWidth: 130.0,
                                        iconedButtons: {
                                          ButtonState.idle: IconedButton(
                                            color: Color(0xffff2079),
                                            icon: Icon(
                                              AntDesign.bells,
                                              color: Colors.white,
                                              size: 0,
                                            ),
                                            text: "Clear",
                                          ),
                                          ButtonState.loading: IconedButton(text: "Loading", color: Color(0xffff2713)),
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
                                              DBProvider.db.removePickupPart();
                                              removeState = ButtonState.idle;
                                            });
                                          });
                                        },
                                        state: removeState,
                                        minWidth: 100.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: ProgressButton.icon(
                                        height: 30.0,
                                        maxWidth: 130.0,
                                        iconedButtons: {
                                          ButtonState.idle: IconedButton(
                                            color: Color(0xffB721FF),
                                            icon: Icon(
                                              AntDesign.bells,
                                              color: Colors.white,
                                              size: 0,
                                            ),
                                            text: "Pickup",
                                          ),
                                          ButtonState.loading: IconedButton(
                                              text: "Loading",
                                              icon: Icon(
                                                AntDesign.bells,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                              color: Colors.deepPurple.shade700),
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
                                                listPickUpBloc.dispatch(FetchUserName());

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
                                ))))
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
            ),
            bottomNavigationBar: BottomAppBar(
              color: Color(0xff6e4dff),
              shape: CircularNotchedRectangle(),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Color(0xffe01094).withOpacity(1),
                        Color(0xffB721FF).withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                        //Navigator.pop(context, "back");
                      },
                      child: Row(
                        children: [
                          Icon(
                            AntDesign.swapleft,
                            color: Colors.white,
                            size: 15,
                          ),
                          Text(
                            '    Home',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/TenderPartsScreen');
                      },
                      child: Row(
                        children: [
                          Text(
                            'Tender   ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Icon(
                            AntDesign.swapright,
                            color: Colors.white,
                            size: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              hoverElevation: 5,
              backgroundColor: Color(0xffa972ff).withOpacity(.5),
              onPressed: () {
                Navigator.of(context).pushNamed('/NewPickUpPartsScreen');
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
                    gradient: LinearGradient(
                      colors: [Color(0xffff2079).withOpacity(0.6), Color(0xffa46bff)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        ),
      );
    }

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

    _generateTransactionList(PickUpPart pickUpPart) {
      if (pickUpPart.isSynced == 0) {
        TransactionRequest transactionRequest = TransactionRequest();

        transactionRequest.handHeldId = _deviceIdValue;
        transactionRequest.id = pickUpPart.id;
        transactionRequest.location = pickUpPart.location;
        transactionRequest.status = Strings.PICKUP;
        transactionRequest.user = _userName;
        transactionRequest.packages = [getPackageFromPickUpPart(pickUpPart)];
        _transactionRequestItems.add(transactionRequest);
      }
    }

    _generateTransactionRequest() {
      pickUpItems.forEach((_generateTransactionList));
    }

    return BlocListener<ListPickUpBloc, ListPickUpState>(
        listener: (context, state) {
          if (state is PickUpPartsListFetchSuccess) {
            pickUpItems.clear();
            pickUpItems.addAll(state.pickUpPartsResponse.reversed);
            _transactionRequestItems.clear(); //Added
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
                listPickUpBloc.dispatch(SendPartsButtonClick(_transactionRequestItems[i], _deviceIdValue, _userName));
              }
            } else {
              print("No transactions to be synced");
            }
          }

          if (state is TransactionLoading) {
            _isLoading = true;
          }

          if (state is PickUpPartsSaved) {
            if (transactionCount != 0 && transactionCount == _transactionRequestItems.length) {
              transactionCount = 0;
              _isLoading = false;
              print(state.message);
              listPickUpBloc.dispatch(ListPickUpPartItemsEvent());
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
