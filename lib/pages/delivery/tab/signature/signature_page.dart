import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';
import 'package:trackaware_lite/blocs/signature_bloc.dart';
import 'package:trackaware_lite/events/signature_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/states/signature_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

class SignaturePage extends StatefulWidget {
  @override
  _SignaturePageState createState() => new _SignaturePageState();
}

List pickUpItems;
var _userName = "";
var _deviceId = "";
int transactionCount = 0;

final SignatureController _controller = SignatureController(
  penStrokeWidth: 5,
  penColor: Colors.black,
  exportBackgroundColor: Colors.white,
);

class _SignaturePageState extends State<SignaturePage> implements AlertClickCallBack {
  var _isLoading = false;

  @override
  void initState() {
    _controller.addListener(() {
      print("Value changed");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signatureBloc = BlocProvider.of<SignatureBloc>(context);
    if (_userName.isEmpty) {
      signatureBloc.dispatch(FetchUserName());
    }

    Widget getDeliveryCompleteButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 26),
          child: Container(
              width: double.infinity,
              child: RaisedButton(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16),
                  child: Text(Strings.DELIVERY_COMPLETE,
                      style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      try {
                        signatureBloc.dispatch(FetchPickUpItems());
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      showAlertDialog(context, Strings.PLEASE_SIGN_TO_PROCEED, null);
                    }
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getScaffold() {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            backgroundColor: HexColor(ColorStrings.boxBackground).withAlpha(30),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: <Widget>[Image.asset("images/ic_back.png")],
              ),
            ),
            middle: Text(Strings.SIGNATURE)),
        child: Stack(
          children: <Widget>[
            //SIGNATURE CANVAS
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 100, 16, 16),
                    child: Container(
                        height: 300,
                        decoration: BoxDecoration(color: HexColor(ColorStrings.WHITE), shape: BoxShape.rectangle, border: Border.all(color: HexColor(ColorStrings.loginBtnBackground), width: 1.0)),
                        child: Signature(
                          controller: _controller,
                          height: 300,
                          backgroundColor: Colors.white,
                        )))),

            //CLEAR CANVAS
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 92, 8, 8),
                    child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() => _controller.clear());
                          },
                        )))),
            Align(alignment: Alignment.bottomCenter, child: getDeliveryCompleteButton()),
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
      );
    }

    Widget getCupertinoScaffold(BuildContext context, SignaturePageState state) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<SignatureBloc, SignaturePageState>(
        listener: (context, state) {
          if (state is FetchPickUpItemsSuccess) {
            pickUpItems = state.pickUpItems;
            if (pickUpItems is List<PickUpPart>) {
              pickUpItems.forEach((element) {
                transactionCount += 1;
                signatureBloc.dispatch(TransactionEvent(transactionRequests: generateTransactionFromPickupPart(element, _deviceId, _userName), transactionRequestCount: 0));
              });
            } else {
              pickUpItems.forEach((element) {
                transactionCount += 1;
                signatureBloc.dispatch(TransactionEvent(transactionRequests: generateTransactionForDeliveryFromPickupExternal(element, _deviceId, _userName), transactionRequestCount: 0));
              });
            }
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            signatureBloc.dispatch(FetchDeviceId());
          }

          if (state is UserNameFetchFailure) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceId = state.deviceId;
          }

          if (state is SignatureLoading) {
            _isLoading = true;
          }

          if (state is TransactionRequestSuccess) {
            if (transactionCount != 0 && transactionCount == pickUpItems.length) {
              transactionCount = 0;
              _isLoading = false;
              globals.refreshDelivery = true;
              print(state.message);
              _controller.clear();
              showAlertDialog(context, "Transactions Complete!", this);
            }
          }

          if (state is TransactionRequestFailure) {
            _isLoading = false;
            print(state.error);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<SignatureBloc, SignaturePageState>(
            bloc: signatureBloc,
            builder: (
              BuildContext context,
              SignaturePageState state,
            ) {
              return getCupertinoScaffold(context, state);
            }));
  }

  @override
  void onClickAction() {
    globals.barCode = "";
    Navigator.pop(context, "refresh");
  }
}
