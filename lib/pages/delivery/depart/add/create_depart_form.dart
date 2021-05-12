import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/create_depart_bloc.dart';
import 'package:trackaware_lite/events/create_depart_event.dart';
import 'package:trackaware_lite/models/depart_db.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/states/create_depart_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

class CreateDepartForm extends StatefulWidget {
  @override
  State<CreateDepartForm> createState() {
    return _CreateDepartFormState();
  }
}

const double _kPickerItemHeight = 32.0;
const double _kPickerSheetHeight = 216.0;

List<LocationResponse> _locationList = List<LocationResponse>();

final trackingNumberController = TextEditingController();
final packagingCountController = TextEditingController();

final FocusNode trackingNumberFocus = FocusNode();
final FocusNode packagingCountFocus = FocusNode();

int _selectedLocationIndex = -1;
bool _isLoading = false;
var createDepartBloc;
var _formKey = GlobalKey<FormState>();
String _deviceIdValue;
String _userName;

class _CreateDepartFormState extends State<CreateDepartForm> {
  @override
  void dispose() {
    trackingNumberController.clear();
    _isLoading = false;
    _locationList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createDepartBloc = BlocProvider.of<CreateDepartBloc>(context);

    _saveDepartItemToDb() {
      if (_validateForm()) {
        createDepartBloc.dispatch(FetchDeviceId());
      }
    }

    Widget _buildLocationPicker(BuildContext context) {
      return GestureDetector(
          onTap: () {
            createDepartBloc.dispatch(LocationViewClick());
          },
          child: new Material(
              color: Colors.transparent,
              child: _locationList.isEmpty || _selectedLocationIndex == -1
                  ? Text("Select location")
                  : Text(
                      _locationList[_selectedLocationIndex].code,
                      style: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.inactiveGray, context)),
                    )));
    }

    Widget getLocationWidget() {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(ColorStrings.BORDER),
              ),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 0, 44),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      "assets/ic_location.svg",
                      semanticsLabel: "location icon",
                    ),
                  )),
              Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                    child: Material(
                        color: Colors.transparent,
                        child: Text(
                          Strings.LOCATION,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: HexColor(ColorStrings.HEADING), fontSize: 12.0, fontStyle: FontStyle.normal),
                        ))),
                Padding(padding: EdgeInsets.fromLTRB(14, 10, 10, 16), child: _buildLocationPicker(context))
              ]))
            ],
          ));
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
                  onPressed: () {
                    _saveDepartItemToDb();
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getTrackingNumberWidget() {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(ColorStrings.BORDER),
              ),
              color: Colors.white),
          child: Row(children: <Widget>[
            Flexible(
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                      child: Material(
                          color: Colors.transparent,
                          child: Text(
                            Strings.TRACKING_NUMBER,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: HexColor(ColorStrings.HEADING), fontSize: 12.0, fontStyle: FontStyle.normal),
                          ))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                      child: new Material(
                          color: Colors.transparent,
                          child: new TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                            autofocus: false,
                            decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_TRACKING_NUMBER),
                            validator: (value) {
                              if (value.isEmpty) {
                                return Strings.TRACKING_NUMBER_VALIDATION_MESSAGE;
                              }
                              return null;
                            },
                            controller: trackingNumberController,
                            textInputAction: TextInputAction.next,
                            focusNode: trackingNumberFocus,
                            onFieldSubmitted: (v) {
                              trackingNumberFocus.unfocus();
                              FocusScope.of(context).requestFocus(packagingCountFocus);
                            },
                          )))
                ]),
                flex: 6),
            Flexible(
                child: GestureDetector(
                  onTap: () {
                    createDepartBloc.dispatch(TrackingNumberScanEvent());
                  },
                  child: Padding(child: Image.asset("images/ic_scan.png"), padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                ),
                flex: 1)
          ]));
    }

    Widget getPackagingCountWidget() {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(ColorStrings.BORDER),
              ),
              color: Colors.white),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                child: Material(
                    color: Colors.transparent,
                    child: Text(
                      Strings.PACKAGING_COUNT,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: HexColor(ColorStrings.HEADING), fontSize: 12.0, fontStyle: FontStyle.normal),
                    ))),
            Padding(
                padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                child: new Material(
                    color: Colors.transparent,
                    child: new TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                      autofocus: false,
                      decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_PACKAGING_COUNT),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.PACKAGING_COUNT_VALIDATION_MESSAGE;
                        }
                        return null;
                      },
                      controller: packagingCountController,
                      textInputAction: TextInputAction.done,
                      focusNode: packagingCountFocus,
                      onFieldSubmitted: (v) {
                        packagingCountFocus.unfocus();
                      },
                    )))
          ]));
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
              middle: Text(Strings.departTitle)),
          child: Form(
              key: _formKey,
              child: Container(
                  child: Stack(children: <Widget>[
                ListView(
                  children: <Widget>[
                    getLocationWidget(),
                    getTrackingNumberWidget(),
                    getPackagingCountWidget(),
                  ],
                ),
                Align(
                  child: getDeliveryCompleteButton(),
                  alignment: AlignmentDirectional.bottomCenter,
                ),
                Align(
                  child: _isLoading
                      ? CupertinoActivityIndicator(
                          animating: true,
                          radius: 20.0,
                        )
                      : Text(""),
                  alignment: AlignmentDirectional.center,
                ),
              ]))));
    }

    Widget getCupertinoScaffold(CreateDepartState state, CreateDepartBloc createArriveBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<CreateDepartBloc, CreateDepartState>(
        listener: (context, state) {
          if (state is TrackingNumberScanSuccess) {
            trackingNumberController.text = state.barCode;
            trackingNumberController.selection = TextSelection.fromPosition(TextPosition(offset: trackingNumberController.text.length));
          }

          if (state is DepartItemSaved) {
            Toast.show("Depart entry created", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            Navigator.pop(context, "saved");
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceIdValue = state.deviceId;
            createDepartBloc.dispatch(FetchUserName());
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            Depart depart = Depart();
            depart.location = _locationList[_selectedLocationIndex].code;
            depart.trackingNo = trackingNumberController.text;
            depart.packageCount = int.parse(packagingCountController.text);
            depart.scanTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
            depart.isSynced = 1;
            createDepartBloc.dispatch(DeliveryCompleteButtonClick(depart, generateDeliveryListFromDepartItem(depart, _deviceIdValue, _userName)));
          }

          if (state is LocationApiCallLoading || state is DeliveryLoading) {
            _isLoading = true;
          }

          if (state is LocationResponseFetchSuccess) {
            _isLoading = false;
            _locationList.clear();
            _locationList.addAll(state.locationResponse);

            final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _selectedLocationIndex);
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _BottomPicker(
                  child: CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: _kPickerItemHeight,
                    backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                    onSelectedItemChanged: (int index) {
                      setState(() => _selectedLocationIndex = index);
                    },
                    children: List<Widget>.generate(_locationList.length, (int index) {
                      return Center(
                        child: Text(_locationList[index].code),
                      );
                    }),
                  ),
                );
              },
            );
          }

          if (state is LocationResponseFetchFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is DepartItemFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CreateDepartBloc, CreateDepartState>(
            bloc: createDepartBloc,
            builder: (
              BuildContext context,
              CreateDepartState state,
            ) {
              return getCupertinoScaffold(state, createDepartBloc);
            }));
  }

  bool _validateForm() {
    if (_selectedLocationIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_LOCATION, null);
      return false;
    }

    return _formKey.currentState.validate();
  }
}

class _BottomPicker extends StatelessWidget {
  const _BottomPicker({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 16.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {
            print("onTap clicked");
          },
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      ),
    );
  }
}
