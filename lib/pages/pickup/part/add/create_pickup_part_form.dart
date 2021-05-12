import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/create_pickup_bloc.dart';
import 'package:trackaware_lite/events/create_pickup_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/states/create_pickup_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

class CreatePickUpPartForm extends StatefulWidget {
  final String barCode;
  final PickUpPart receivedPickUpPart;

  CreatePickUpPartForm(this.barCode, this.receivedPickUpPart);

  @override
  State<CreatePickUpPartForm> createState() {
    return _CreatePickUpPartFormFormState(barCode, receivedPickUpPart);
  }
}

final orderNumberController = TextEditingController();
final partNumberController = TextEditingController();
bool _isKeepScannedValues = false;

final FocusNode orderNumberFocus = FocusNode();
final FocusNode partNumberFocus = FocusNode();

const double _kPickerItemHeight = 32.0;
const double _kPickerSheetHeight = 216.0;

List<LocationResponse> _locationList = List<LocationResponse>();
List<LocationResponse> _destinationList = List<LocationResponse>();

int _selectedLocationIndex = -1;
int _selectedDestinationIndex = -1;
bool _isLoading = false;
var createPickUpBloc;
final _formKey = GlobalKey<FormState>();

String _deviceIdValue;
String _userName;

class _CreatePickUpPartFormFormState extends State<CreatePickUpPartForm> {
  var barcode;
  PickUpPart receivedPickUpPart;
  _CreatePickUpPartFormFormState(this.barcode, this.receivedPickUpPart);

  @override
  void dispose() {
    orderNumberController.clear();
    partNumberController.clear();
    _isKeepScannedValues = false;
    _isLoading = false;
    _locationList.clear();
    _destinationList.clear();
    _selectedLocationIndex = -1;
    _selectedDestinationIndex = -1;
    globals.selectedPickUpPart = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createPickUpBloc = BlocProvider.of<CreatePickUpBloc>(context);

    _savePickUpPartToDb() {
      if (_validateForm()) {
        createPickUpBloc.dispatch(FetchDeviceId());
      }
    }

    Widget _buildLocationPicker(BuildContext context) {
      return new Material(
          color: Colors.transparent,
          child: _locationList.isEmpty || _selectedLocationIndex == -1
              ? Text("Select location")
              : Text(
                  _locationList[_selectedLocationIndex].code,
                  style: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.inactiveGray, context)),
                ));
    }

    Widget _buildDestinationPicker(BuildContext context) {
      return new Material(
          color: Colors.transparent,
          child: _destinationList.isEmpty || _selectedDestinationIndex == -1
              ? Text("Select Destination")
              : Text(
                  _destinationList[_selectedDestinationIndex].code,
                  style: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.inactiveGray, context)),
                ));
    }

    Widget getLocationWidget() {
      return GestureDetector(
          onTap: () {
            createPickUpBloc.dispatch(LocationViewClick());
          },
          child: Container(
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
                    Padding(
                        padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                        child:
                            receivedPickUpPart != null && _selectedLocationIndex == -1 ? Material(color: Colors.transparent, child: Text(receivedPickUpPart.location)) : _buildLocationPicker(context))
                  ]))
                ],
              )));
    }

    Widget getDestinationWidget() {
      return GestureDetector(
          onTap: () {
            createPickUpBloc.dispatch(DestinationViewClick());
          },
          child: Container(
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
                          "assets/ic_destination_location.svg",
                          semanticsLabel: "quantity icon",
                        ),
                      )),
                  Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                        child: Material(
                            color: Colors.transparent,
                            child: Text(
                              Strings.DESTINATION,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: HexColor(ColorStrings.HEADING), fontSize: 12.0, fontStyle: FontStyle.normal),
                            ))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                        child: receivedPickUpPart != null && _selectedDestinationIndex == -1
                            ? Material(
                                color: Colors.transparent,
                                child: Text(receivedPickUpPart.destination),
                              )
                            : _buildDestinationPicker(context))
                  ]))
                ],
              )));
    }

    Widget getOrderNumberWidget() {
      if (receivedPickUpPart != null) {
        orderNumberController.text = receivedPickUpPart.orderNumber;
        orderNumberController.selection = TextSelection.fromPosition(TextPosition(offset: orderNumberController.text.length));
      } else if (globals.orderNumber.isNotEmpty) {
        orderNumberController.text = globals.orderNumber;
        orderNumberController.selection = TextSelection.fromPosition(TextPosition(offset: orderNumberController.text.length));
      }
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(ColorStrings.BORDER),
              ),
              color: Colors.white),
          child: Row(children: <Widget>[
            Flexible(
                child: GestureDetector(
                    onTap: () {
                      partNumberFocus.unfocus();
                      FocusScope.of(context).requestFocus(orderNumberFocus);
                    },
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                          child: Material(
                              color: Colors.transparent,
                              child: Text(
                                Strings.ORDER_NUMBER,
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
                                decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_ORDER_NUMBER),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return Strings.ORDER_NUMBER_VALIDATION_MESSAGE;
                                  }
                                  return null;
                                },
                                controller: orderNumberController,
                                textInputAction: TextInputAction.next,
                                focusNode: orderNumberFocus,
                                onFieldSubmitted: (v) {
                                  orderNumberFocus.unfocus();
                                  FocusScope.of(context).requestFocus(partNumberFocus);
                                },
                              )))
                    ])),
                flex: 6),
            Flexible(
                child: GestureDetector(
                  onTap: () {
                    globals.scanOption = Strings.CREATE_PICKUP_PRODUCTION_PARTS;
                    createPickUpBloc.dispatch(OrderNumberScanEvent());
                  },
                  child: Padding(child: Image.asset("images/ic_scan.png"), padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                ),
                flex: 1)
          ]));
    }

    Widget getPartNumberWidget() {
      if (receivedPickUpPart != null) {
        partNumberController.text = receivedPickUpPart.partNumber;
        partNumberController.selection = TextSelection.fromPosition(TextPosition(offset: partNumberController.text.length));
      } else if (globals.partNumber.isNotEmpty) {
        partNumberController.text = globals.partNumber;
        partNumberController.selection = TextSelection.fromPosition(TextPosition(offset: partNumberController.text.length));
      }

      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(ColorStrings.BORDER),
              ),
              color: Colors.white),
          child: Row(children: <Widget>[
            Flexible(
                child: GestureDetector(
                    onTap: () {
                      orderNumberFocus.unfocus();
                      FocusScope.of(context).requestFocus(partNumberFocus);
                    },
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                          child: Material(
                              color: Colors.transparent,
                              child: Text(
                                Strings.PART_NUMBER,
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
                                decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_PART_NUMBER),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return Strings.TRACKING_NUMBER_VALIDATION_MESSAGE;
                                  }
                                  return null;
                                },
                                controller: partNumberController,
                                textInputAction: TextInputAction.done,
                                focusNode: partNumberFocus,
                                onFieldSubmitted: (v) {
                                  partNumberFocus.unfocus();
                                },
                              )))
                    ])),
                flex: 6),
            Flexible(
                child: GestureDetector(
                  onTap: () {
                    globals.scanOption = Strings.CREATE_PICKUP_PRODUCTION_PARTS;
                    createPickUpBloc.dispatch(PartNumberScanEvent());
                  },
                  child: Padding(child: Image.asset("images/ic_scan.png"), padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                ),
                flex: 1)
          ]));
    }

    Widget getCheckBox(CreatePickUpState state, CreatePickUpBloc createExternalTenderBloc) {
      if (receivedPickUpPart != null) {
        _isKeepScannedValues = receivedPickUpPart.keepScannedValues == 1;
      }
      return Row(
        children: <Widget>[
          Material(
              color: Colors.transparent,
              child: Checkbox(
                checkColor: Colors.white,
                activeColor: HexColor(ColorStrings.KEEP_SCANNED_VALUES),
                value: state is CheckBoxChecked ? true : _isKeepScannedValues,
                onChanged: (bool value) {
                  _isKeepScannedValues = value;
                  createExternalTenderBloc.dispatch(new CheckBoxClick(isChecked: _isKeepScannedValues));
                },
              )),
          Expanded(
              child: Material(
                  color: Colors.transparent,
                  child: Text(
                    Strings.KEEP_SCANNED_VALUES,
                    style: const TextStyle(color: const Color(0xff030303), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0),
                  ))),
        ],
      );
    }

    Widget getSendButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 26),
          child: Container(
              width: double.infinity,
              child: RaisedButton(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16),
                  child: Text(receivedPickUpPart != null ? Strings.SEND : Strings.ADD_TO_LIST,
                      style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
                  onPressed: () {
                    _savePickUpPartToDb();
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getScaffold(CreatePickUpState state, CreatePickUpBloc createPickUpBloc) {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              backgroundColor: HexColor(ColorStrings.boxBackground).withAlpha(30),
              leading: GestureDetector(
                onTap: () {
                  navigateBack();
                },
                child: Row(
                  children: <Widget>[Image.asset("images/ic_back.png")],
                ),
              ),
              middle: Text(Strings.NEW_PICKUP_PART)),
          child: Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        getLocationWidget(),
                        getDestinationWidget(),
                        getOrderNumberWidget(),
                        getPartNumberWidget(),
                        getCheckBox(state, createPickUpBloc),
                      ],
                    ),
                    Align(child: getSendButton(), alignment: AlignmentDirectional.bottomCenter),
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

    Widget getCupertinoScaffold(CreatePickUpState state, createPickUpBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                navigateBack();
                return;
              },
              child: getScaffold(state, createPickUpBloc))
          : getScaffold(state, createPickUpBloc);
    }

    return BlocListener<CreatePickUpBloc, CreatePickUpState>(
        listener: (context, state) {
          if (state is ScanOptionFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is OrderNumberScanSuccess) {
            globals.orderNumber = state.barCode;
            orderNumberController.text = globals.orderNumber;
            orderNumberController.selection = TextSelection.fromPosition(TextPosition(offset: orderNumberController.text.length));
          }

          if (state is PartNumberScanSuccess) {
            globals.partNumber = state.barCode;
            partNumberController.text = globals.refNumber;
            partNumberController.selection = TextSelection.fromPosition(TextPosition(offset: partNumberController.text.length));
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceIdValue = state.deviceId;
            createPickUpBloc.dispatch(FetchUserName());
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            PickUpPart pickUpPart;
            if (receivedPickUpPart != null) {
              pickUpPart = receivedPickUpPart;
              if (_locationList.isNotEmpty) pickUpPart.location = _selectedLocationIndex != -1 ? _locationList[_selectedLocationIndex].code : receivedPickUpPart.location;
              if (_destinationList.isNotEmpty) pickUpPart.destination = _selectedDestinationIndex != -1 ? _destinationList[_selectedDestinationIndex].code : receivedPickUpPart.destination;
              pickUpPart.orderNumber = orderNumberController.text;
              pickUpPart.partNumber = partNumberController.text;
              createPickUpBloc.dispatch(SendPartsButtonClick(generateTransactionFromPickupPart(pickUpPart, _deviceIdValue, _userName), pickUpPart));
            } else {
              pickUpPart = PickUpPart();
              pickUpPart.location = _locationList[_selectedLocationIndex].code;
              pickUpPart.destination = _destinationList[_selectedDestinationIndex].code;
              pickUpPart.orderNumber = orderNumberController.text;
              pickUpPart.partNumber = partNumberController.text;
              pickUpPart.scanTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
              pickUpPart.isSynced = 0;
              pickUpPart.isScanned = 0;
              pickUpPart.isDelivered = 0;
              pickUpPart.keepScannedValues = _isKeepScannedValues ? 1 : 0;
              createPickUpBloc.dispatch(AddToListPartButtonClick(pickUpPart));
            }
          }

          if (state is PickUpPartsSaved) {
            globals.orderNumber = "";
            globals.partNumber = "";
            Toast.show(state.message, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            globals.selectedPickUpPart = null;
            Navigator.pop(context, "saved");
          }

          if (state is AddToListPartSuccess) {
            resetValues();
            Navigator.pop(context, "Saved");
          }

          if (state is PickUpApiCallLoading ||
              state is DeliverySiteApiCallLoading ||
              state is LocationApiCallLoading ||
              state is DestinationApiCallLoading ||
              state is PackageDetailsApiCallLoading ||
              state is TransactionLoading) {
            _isLoading = true;
          }

          if (state is LocationResponseFetchSuccess) {
            _isLoading = false;
            _locationList.clear();
            _locationList.addAll(state.locationResponse);

            if (receivedPickUpPart != null) {
              for (int i = 0; i < _locationList.length; i++) {
                if (_locationList[i].code == receivedPickUpPart.location) {
                  _selectedLocationIndex = i;
                }
              }
            }

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

          if (state is DestinationResponseFetchSuccess) {
            _isLoading = false;
            _destinationList.clear();
            _destinationList.addAll(state.locationResponse);

            if (receivedPickUpPart != null) {
              for (int i = 0; i < _destinationList.length; i++) {
                if (_destinationList[i].code == receivedPickUpPart.destination) {
                  _selectedDestinationIndex = i;
                }
              }
            }

            final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _selectedDestinationIndex);
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _BottomPicker(
                  child: CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: _kPickerItemHeight,
                    backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                    onSelectedItemChanged: (int index) {
                      setState(() => _selectedDestinationIndex = index);
                    },
                    children: List<Widget>.generate(_destinationList.length, (int index) {
                      return Center(
                        child: Text(_destinationList[index].code),
                      );
                    }),
                  ),
                );
              },
            );
          }

          if (state is PickUpSiteResponseFetchFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is DeliverySiteResponseFetchFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
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

          if (state is DestinationResponseFetchFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CreatePickUpBloc, CreatePickUpState>(
            bloc: createPickUpBloc,
            builder: (
              BuildContext context,
              CreatePickUpState state,
            ) {
              return getCupertinoScaffold(state, createPickUpBloc);
            }));
  }

  bool _validateForm() {
    if (receivedPickUpPart == null && _selectedLocationIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_LOCATION, null);
      return false;
    } else if (receivedPickUpPart == null && _selectedDestinationIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_DESTINATION, null);
      return false;
    }
    return _formKey.currentState.validate();
  }

  void resetValues() {
    globals.orderNumber = "";
    globals.partNumber = "";
  }

  void navigateBack() {
    resetValues();
    Navigator.pop(context);
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
