import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/create_external_tender_bloc.dart';
import 'package:trackaware_lite/events/create_external_tender_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/states/create_external_tender_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

class CreateTenderPartsForm extends StatefulWidget {
  final String barCode;

  CreateTenderPartsForm(this.barCode);

  @override
  State<CreateTenderPartsForm> createState() {
    return _CreateTenderPartsFormState();
  }
}

final quantityController = TextEditingController();
final orderNumberController = TextEditingController();
final partNumberController = TextEditingController();
final toolNumberController = TextEditingController();

final FocusNode quantityFocus = FocusNode();
final FocusNode orderNumberFocus = FocusNode();
final FocusNode partNumberFocus = FocusNode();
final FocusNode toolNumberFocus = FocusNode();

const double _kPickerItemHeight = 32.0;
const double _kPickerSheetHeight = 216.0;

List<PriorityResponse> _priorityList = List<PriorityResponse>(); // ignore: deprecated_member_use
List<LocationResponse> _locationList = List<LocationResponse>(); // ignore: deprecated_member_use
List<LocationResponse> _destinationList = List<LocationResponse>(); // ignore: deprecated_member_use

int _selectedPriorityIndex = 1;
int _selectedLocationIndex = -1;
int _selectedDestinationIndex = -1;
bool _isLoading = false;
bool _isKeepScannedValues = false;
var createExternalTenderBloc;
var _formKey = GlobalKey<FormState>();

String _deviceIdValue;
String _userName;

class _CreateTenderPartsFormState extends State<CreateTenderPartsForm> {
  _CreateTenderPartsFormState();
//SCAN SETTINGS

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    quantityController.clear();
    orderNumberController.clear();
    partNumberController.clear();
    toolNumberController.clear();
    _isLoading = false;
    _isKeepScannedValues = false;
    _locationList.clear();
    _destinationList.clear();
    _priorityList.clear();
    _selectedLocationIndex = -1;
    _selectedDestinationIndex = -1;
    globals.tenderParts = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createExternalTenderBloc = BlocProvider.of<CreateExternalTenderBloc>(context);

    _saveTenderExternalToDb() {
      if (globals.tenderParts != null || _validateForm()) {
        createExternalTenderBloc.dispatch(FetchDeviceId());
      }
    }

    Widget _buildPriorityPicker(BuildContext context) {
      return new Material(
          color: Colors.transparent,
          child: _priorityList.isEmpty || _selectedPriorityIndex == -1
              ? Text(" ")
              : Text(
                  _priorityList[_selectedPriorityIndex].code,
                  style: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.inactiveGray, context)),
                ));
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

    Widget _buildDestLocationPicker(BuildContext context) {
      return new Material(
          color: Colors.transparent,
          child: _destinationList.isEmpty || _selectedDestinationIndex == -1
              ? Text("Select destination")
              : Text(
                  _destinationList[_selectedDestinationIndex].code,
                  style: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.inactiveGray, context)),
                ));
    }

    Widget getPriorityWidget() {
      return GestureDetector(
          onTap: () {
            createExternalTenderBloc.dispatch(PriorityViewClick());
          },
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: HexColor(ColorStrings.BORDER),
                  ),
                  color: Colors.white),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 0, 44),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        "assets/ic_priority.svg",
                        semanticsLabel: "priority icon",
                        width: 24,
                        height: 24,
                      ),
                    )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                        child: Material(
                            color: Colors.transparent,
                            child: Text(
                              Strings.PRIORITY,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: HexColor(ColorStrings.HEADING), fontSize: 12.0, fontStyle: FontStyle.normal),
                            ))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                        child: globals.tenderParts != null && _selectedPriorityIndex == -1
                            ? Material(color: Colors.transparent, child: Text(globals.tenderParts.priority))
                            : _buildPriorityPicker(context))
                  ],
                ))
              ])));
    }

    Widget getQuantityWidget() {
      if (globals.tenderParts != null) {
        quantityController.text = globals.tenderParts.quantity.toString();
      }
      return GestureDetector(
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
                        "assets/ic_number.svg",
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
                            Strings.QUANTITY,
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
                            decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: "Enter quantity"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return Strings.QUANTITY_VALIDATION_MESSAGE;
                              }
                              return null;
                            },
                            controller: quantityController,
                            textInputAction: TextInputAction.next,
                            focusNode: quantityFocus,
                            onFieldSubmitted: (v) {
                              quantityFocus.unfocus();
                              FocusScope.of(context).requestFocus(orderNumberFocus);
                            },
                          )))
                ]))
              ],
            )),
        onTap: () {
          orderNumberFocus.unfocus();
          partNumberFocus.unfocus();
          toolNumberFocus.unfocus();
          FocusScope.of(context).requestFocus(quantityFocus);
        },
      );
    }

    Widget getLocationWidget() {
      return GestureDetector(
          onTap: () {
            createExternalTenderBloc.dispatch(LocationViewClick());
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
                        child: globals.tenderParts != null && _selectedLocationIndex == -1
                            ? Material(color: Colors.transparent, child: Text(globals.tenderParts.location))
                            : _buildLocationPicker(context))
                  ]))
                ],
              )));
    }

    Widget getDestinationLocationWidget() {
      return GestureDetector(
          onTap: () {
            createExternalTenderBloc.dispatch(DestinationViewClick());
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
                        child: globals.tenderParts != null && _selectedDestinationIndex == -1
                            ? Material(color: Colors.transparent, child: Text(globals.tenderParts.destination))
                            : _buildDestLocationPicker(context))
                  ]))
                ],
              )));
    }

    Widget getOrderNumberWidget() {
      if (globals.tenderParts?.orderNumber?.isNotEmpty == true) {
        orderNumberController.text = globals.tenderParts.orderNumber;
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
                      quantityFocus.unfocus();
                      partNumberFocus.unfocus();
                      toolNumberFocus.unfocus();
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
                                onChanged: (value) async {
                                  if (value.length == 9 || value.length == 11) {
                                    print('yes');
                                    orderNumberFocus.unfocus();
                                    FocusScope.of(context).requestFocus(partNumberFocus);
                                  }
                                },
                                onTap: () {
                                  setState(() {});
                                },
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
          ]));
    }

    Widget getPartNumberWidget() {
      if (globals.tenderParts?.partNumber?.isNotEmpty == true) {
        partNumberController.text = globals.tenderParts.partNumber;
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
                      quantityFocus.unfocus();
                      toolNumberFocus.unfocus();

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
                                onChanged: (value) async {
                                  if (value.length == 14 || value.length == 11) {
                                    partNumberFocus.unfocus();
                                    if (globals.toolNumber != null && globals.toolNumber.isNotEmpty) {
                                      FocusScope.of(context).requestFocus(toolNumberFocus);
                                    }
                                  }
                                },
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                                style: TextStyle(color: HexColor(ColorStrings.VALUES), fontSize: 16),
                                autofocus: false,
                                decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_PART_NUMBER),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return Strings.PART_NUMBER_VALIDATION_MESSAGE;
                                  }
                                  return null;
                                },
                                controller: partNumberController,
                                textInputAction: TextInputAction.next,
                                focusNode: partNumberFocus,
                                onFieldSubmitted: (v) {
                                  partNumberFocus.unfocus();
                                  if (globals.toolNumber != null && globals.toolNumber.isNotEmpty) {
                                    FocusScope.of(context).requestFocus(toolNumberFocus);
                                  }
                                },
                              )))
                    ])),
                flex: 6),
          ]));
    }

    Widget getToolNumberWidget() {
      if (globals.toolNumber != null && globals.toolNumber.isNotEmpty) {
        toolNumberController.text = globals.toolNumber;
        toolNumberController.selection = TextSelection.fromPosition(TextPosition(offset: toolNumberController.text.length));
      }
      return Visibility(
          visible: globals.useToolNumber,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: HexColor(ColorStrings.BORDER),
                  ),
                  color: Colors.white),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: GestureDetector(
                          onTap: () {
                            quantityFocus.unfocus();
                            orderNumberFocus.unfocus();
                            partNumberFocus.unfocus();
                            FocusScope.of(context).requestFocus(toolNumberFocus);
                          },
                          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                                child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      Strings.TOOL_NUMBER,
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
                                      decoration: InputDecoration.collapsed(focusColor: HexColor(ColorStrings.emailPwdTextColor), hintText: Strings.ENTER_TOOL_NUMBER),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return Strings.TOOL_NUMBER_VALIDATION_MESSAGE;
                                        }
                                        return null;
                                      },
                                      controller: toolNumberController,
                                      textInputAction: TextInputAction.done,
                                      focusNode: toolNumberFocus,
                                      onFieldSubmitted: (v) {
                                        toolNumberFocus.unfocus();
                                      },
                                    )))
                          ])),
                      flex: 6),
                ],
              )));
    }

    Widget getCheckBox(CreateExternalTenderState state, CreateExternalTenderBloc createExternalTenderBloc) {
      if (globals.tenderParts != null) {
        _isKeepScannedValues = globals.tenderParts.keepScannedValues == 1;
      }
      return Row(
        children: <Widget>[
          Material(
              color: Colors.transparent,
              child: Checkbox(
                checkColor: Colors.white,
                activeColor: HexColor(ColorStrings.KEEP_SCANNED_VALUES),
                value: _isKeepScannedValues,
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
          child: RaisedButton(
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(16),
              child: Text(globals.tenderParts != null ? Strings.SEND : Strings.ADD_TO_LIST,
                  style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
              onPressed: () {
                createExternalTenderBloc.dispatch(FetchPriorityResponse());

                /*Navigator.of(context)
                    .pushNamed('/TenderPartsScreen');*/
              },
              color: const Color(0xff424e53)));
    }

    Widget getScaffold(CreateExternalTenderState state) {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: HexColor(ColorStrings.boxBackground).withAlpha(30),
            leading: GestureDetector(
              onTap: () {
                navBack();
              },
              child: Row(
                children: <Widget>[Image.asset("images/ic_back.png")],
              ),
            ),
            middle: Text(Strings.NEW_TENDER_PARTS),
          ),
          child: Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        getPriorityWidget(),
                        getQuantityWidget(),
                        getLocationWidget(),
                        getDestinationLocationWidget(),
                        getOrderNumberWidget(),
                        getPartNumberWidget(),
                        getToolNumberWidget(),
                        getCheckBox(state, createExternalTenderBloc),
                        getSendButton()
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
                    ),
                  ]))));
    }

    Widget getCupertinoScaffold(CreateExternalTenderState state, createExternalTenderBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                navBack();
                return;
              },
              child: getScaffold(state))
          : getScaffold(state);
    }

    return BlocListener<CreateExternalTenderBloc, CreateExternalTenderState>(
        listener: (context, state) {
          if (state is ScanOptionFailure) {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
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
            partNumberController.text = globals.partNumber;
            partNumberController.selection = TextSelection.fromPosition(TextPosition(offset: partNumberController.text.length));
          }

          if (state is ToolNumberScanSuccess) {
            globals.toolNumber = state.barCode;
            toolNumberController.text = globals.toolNumber;
          }

          if (state is ScanSuccess) {
            orderNumberController.text = state.barCode;
            orderNumberController.selection = TextSelection.fromPosition(TextPosition(offset: orderNumberController.text.length));
          }
          if (state is TenderPartsSaved) {
            resetValues();
            Toast.show("Tender part created", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            Navigator.pop(context, "refresh");
          }

          if (state is AddToListExternalSuccess) {
            resetValues();
            Navigator.pop(context, "Saved");
          }

          if (state is PriorityApiCallLoading || state is LocationApiCallLoading || state is DestinationApiCallLoading) {
            _isLoading = true;
          }

          if (state is PriorityResponseFetchFailure) {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is InitPriorityResponseFetchFailure) {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is InitPriorityResponseFetchSuccess) {
            _isLoading = false;

            _priorityList.clear();
            _priorityList.addAll(state.priorityResponse);
            _saveTenderExternalToDb();
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceIdValue = state.deviceId;
            createExternalTenderBloc.dispatch(FetchUserName());
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            if (globals.tenderParts != null) {
              createExternalTenderBloc
                  .dispatch(SendPartsButtonClick(generateTransactionListFromTenderParts(globals.tenderParts, _deviceIdValue, _userName), globals.tenderParts, _deviceIdValue, _userName));
            } else {
              TenderParts tenderParts = TenderParts();
              tenderParts.priority = _priorityList[_selectedPriorityIndex].code;
              tenderParts.quantity = int.parse(quantityController.text);
              tenderParts.location = _locationList[_selectedLocationIndex].code;
              tenderParts.destination = _destinationList[_selectedDestinationIndex].code;
              tenderParts.orderNumber = orderNumberController.text;
              tenderParts.partNumber = partNumberController.text;
              tenderParts.toolNumber = toolNumberController.text;
              tenderParts.keepScannedValues = _isKeepScannedValues ? 1 : 0;
              tenderParts.scanTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
              tenderParts.isSynced = 0;
              tenderParts.isScanned = 0;
              createExternalTenderBloc.dispatch(AddToListPartButtonClick(tenderParts));
            }
          }

          if (state is PriorityResponseFetchSuccess) {
            _isLoading = false;

            _priorityList.clear();
            _priorityList.addAll(state.priorityResponse);

            final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _selectedPriorityIndex);
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _BottomPicker(
                  child: CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: _kPickerItemHeight,
                    backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                    onSelectedItemChanged: (int index) {
                      setState(() => _selectedPriorityIndex = index);
                    },
                    children: List<Widget>.generate(_priorityList.length, (int index) {
                      return Center(
                        child: Text(_priorityList[index].code),
                      );
                    }),
                  ),
                );
              },
            );
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

          if (state is DestinationResponseFetchSuccess) {
            _isLoading = false;
            _destinationList.clear();
            _destinationList.addAll(state.locationResponse);

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

          if (state is AddToListPartSuccess) {
            resetValues();
            Navigator.pop(context, "Saved");
          }

          if (state is LocationResponseFetchFailure) {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is DestinationResponseFetchFailure) {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CreateExternalTenderBloc, CreateExternalTenderState>(
            bloc: createExternalTenderBloc,
            builder: (
              BuildContext context,
              CreateExternalTenderState state,
            ) {
              return getCupertinoScaffold(state, createExternalTenderBloc);
            }));
  }

  bool _validateForm() {
    if (_selectedLocationIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_LOCATION, null);
      return false;
    }

    if (_selectedPriorityIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_PRIORITY, null);
      return false;
    }

    if (_selectedDestinationIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_DESTINATION, null);
      return false;
    }

    return _formKey.currentState.validate();
  }

  void resetValues() {
    globals.orderNumber = "";
    globals.partNumber = "";
    globals.toolNumber = "";
    globals.tenderParts = null;
  }

  void navBack() {
    resetValues();
    Navigator.pop(context, "back");
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
