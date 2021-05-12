import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/create_pickup_bloc.dart';
import 'package:trackaware_lite/events/create_pickup_event.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/package_details_response.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/states/create_pickup_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

class CreateExternalPickUpForm extends StatefulWidget {
  final String barCode;
  final PickUpExternal pickUpExternal;

  CreateExternalPickUpForm(this.barCode, this.pickUpExternal);

  @override
  State<CreateExternalPickUpForm> createState() {
    return _CreateExternalPickUpFormFormState(barCode, pickUpExternal);
  }
}

final trackingNumberController = TextEditingController();

final FocusNode trackingNumberFocus = FocusNode();

const double _kPickerItemHeight = 32.0;
const double _kPickerSheetHeight = 216.0;

List<LocationResponse> _pickUpSiteList = List<LocationResponse>();
List<LocationResponse> _deliverySiteList = List<LocationResponse>();

int _selectedPickUpSiteIndex = -1;
int _selectedDeliverySiteIndex = -1;
bool _isLoading = false;
var createExternalPickUpBloc;
final _formKey = GlobalKey<FormState>();

String _deviceIdValue;
String _userName;

class _CreateExternalPickUpFormFormState extends State<CreateExternalPickUpForm> {
  var barcode;
  PickUpExternal pickUpExternal;
  _CreateExternalPickUpFormFormState(this.barcode, this.pickUpExternal);

  @override
  void dispose() {
    trackingNumberController.clear();
    _isLoading = false;
    _pickUpSiteList.clear();
    _deliverySiteList.clear();
    _selectedDeliverySiteIndex = -1;
    _selectedPickUpSiteIndex = -1;
    globals.selectedPickUpExternal = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createExternalPickUpBloc = BlocProvider.of<CreatePickUpBloc>(context);

    String _generateTagArray() {
      String tag = "{TagId=" + "'" + trackingNumberController.text + "'}";
      List<String> tagList = List();
      tagList.add(tag);
      return tagList.toString();
    }

    _sendPickUpToDb(List<PackageDetailsResponse> packageDetails) {
      if (_validateForm()) {
        PickUpExternal pickUpExternalItem;
        if (packageDetails != null && packageDetails.isNotEmpty && packageDetails[0].destination != null && packageDetails[0].destination.isNotEmpty) {
          if (pickUpExternal != null) {
            pickUpExternalItem = pickUpExternal;
          } else {
            pickUpExternalItem = PickUpExternal();
          }
          pickUpExternalItem.pickUpSite = _selectedPickUpSiteIndex != -1 ? _pickUpSiteList[_selectedPickUpSiteIndex].code : pickUpExternal.pickUpSite;
          pickUpExternalItem.deliverySite = _selectedDeliverySiteIndex != -1 ? packageDetails[0].destination : pickUpExternal.deliverySite;
          pickUpExternalItem.trackingNumber = trackingNumberController.text;
          pickUpExternalItem.scanTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
          pickUpExternalItem.isSynced = 1;
          pickUpExternalItem.isScanned = 0;
          pickUpExternalItem.isDelivered = 0;
          pickUpExternalItem.isPart = 0;
          if (pickUpExternal != null) {
            createExternalPickUpBloc.dispatch(SendButtonClick(generateTransactionFromPickupExternal(pickUpExternalItem, _deviceIdValue, _userName), pickUpExternal));
          } else {
            pickUpExternalItem.isSynced = 0;
            createExternalPickUpBloc.dispatch(AddToListExternalButtonClick(pickUpExternalItem));
          }
        } else {
          PickUpExternal pickUpExternalItem;
          if (pickUpExternal != null) {
            pickUpExternalItem = pickUpExternal;
          } else {
            pickUpExternalItem = PickUpExternal();
          }
          pickUpExternalItem.pickUpSite = _selectedPickUpSiteIndex != -1 && _pickUpSiteList.isNotEmpty ? _pickUpSiteList[_selectedPickUpSiteIndex].code : pickUpExternal.pickUpSite;
          pickUpExternalItem.deliverySite = _selectedDeliverySiteIndex != -1 ? _deliverySiteList[_selectedDeliverySiteIndex].code : pickUpExternal.deliverySite;
          pickUpExternalItem.trackingNumber = trackingNumberController.text;
          pickUpExternalItem.scanTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
          pickUpExternalItem.isSynced = 1;
          pickUpExternalItem.isScanned = 0;
          pickUpExternalItem.isDelivered = 0;
          pickUpExternalItem.isPart = 0;
          if (pickUpExternal != null) {
            createExternalPickUpBloc.dispatch(SendButtonClick(generateTransactionFromPickupExternal(pickUpExternalItem, _deviceIdValue, _userName), pickUpExternal));
          } else {
            pickUpExternalItem.isSynced = 0;
            createExternalPickUpBloc.dispatch(AddToListExternalButtonClick(pickUpExternalItem));
          }
        }
      }
    }

    _savePickUpExternalToDb() {
      createExternalPickUpBloc.dispatch(PackageDetailsValidation(_generateTagArray()));
    }

    Widget _buildPickUpSitePicker(BuildContext context) {
      return new Material(
          color: Colors.transparent,
          child: _pickUpSiteList.isEmpty || _selectedPickUpSiteIndex == -1
              ? Text("Select pickup site")
              : Text(
                  _pickUpSiteList[_selectedPickUpSiteIndex].code,
                  style: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.inactiveGray, context)),
                ));
    }

    Widget _buildDeliverySiteLocationPicker(BuildContext context) {
      return new Material(
          color: Colors.transparent,
          child: _deliverySiteList.isEmpty || _selectedDeliverySiteIndex == -1
              ? Text("Select Delivery Site")
              : Text(
                  _deliverySiteList[_selectedDeliverySiteIndex].code,
                  style: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.inactiveGray, context)),
                ));
    }

    Widget getPickUpSiteWidget() {
      return GestureDetector(
          onTap: () {
            createExternalPickUpBloc.dispatch(PickUpSiteViewClick());
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
                              Strings.PICK_UP_SITE,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: HexColor(ColorStrings.HEADING), fontSize: 12.0, fontStyle: FontStyle.normal),
                            ))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                        child: pickUpExternal != null && _selectedPickUpSiteIndex == -1 ? Material(color: Colors.transparent, child: Text(pickUpExternal.pickUpSite)) : _buildPickUpSitePicker(context))
                  ]))
                ],
              )));
    }

    Widget getDeliverySiteLocationWidget() {
      return GestureDetector(
          onTap: () {
            createExternalPickUpBloc.dispatch(DeliverySiteViewClick());
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
                              Strings.DELIVERY_SITE,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: HexColor(ColorStrings.HEADING), fontSize: 12.0, fontStyle: FontStyle.normal),
                            ))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                        child: pickUpExternal != null && _selectedDeliverySiteIndex == -1
                            ? Material(color: Colors.transparent, child: Text(pickUpExternal.deliverySite))
                            : _buildDeliverySiteLocationPicker(context))
                  ]))
                ],
              )));
    }

    Widget getTrackingNumberWidget() {
      if (pickUpExternal != null) {
        trackingNumberController.text = pickUpExternal.trackingNumber;
        trackingNumberController.selection = TextSelection.fromPosition(TextPosition(offset: trackingNumberController.text.length));
      } else if (globals.trackingNumber.isNotEmpty) {
        trackingNumberController.text = globals.trackingNumber;
        trackingNumberController.selection = TextSelection.fromPosition(TextPosition(offset: trackingNumberController.text.length));
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
                      FocusScope.of(context).requestFocus(trackingNumberFocus);
                    },
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
                                textInputAction: TextInputAction.done,
                                focusNode: trackingNumberFocus,
                                onFieldSubmitted: (v) {
                                  trackingNumberFocus.unfocus();
                                },
                              )))
                    ])),
                flex: 6),
            Flexible(
                child: GestureDetector(
                  onTap: () {
                    globals.scanOption = Strings.CREATE_PICKUP_EXTERNAL_PACKAGES;
                    createExternalPickUpBloc.dispatch(TrackingNumberScanEvent());
                  },
                  child: Padding(child: Image.asset("images/ic_scan.png"), padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                ),
                flex: 1)
          ]));
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
                  child: Text(pickUpExternal != null ? Strings.SEND : Strings.ADD_TO_LIST,
                      style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
                  onPressed: () {
                    createExternalPickUpBloc.dispatch(FetchDeviceId());
                    // _savePickUpExternalToDb();
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getScaffold() {
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
              middle: Text(Strings.NEW_PICKUP_EXTERNAL)),
          child: Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        getPickUpSiteWidget(),
                        getDeliverySiteLocationWidget(),
                        getTrackingNumberWidget(),
                      ],
                    ),
                    Align(
                      child: getSendButton(),
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

    Widget getCupertinoScaffold(CreatePickUpState state, createExternalTenderBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                navigateBack();
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<CreatePickUpBloc, CreatePickUpState>(
        listener: (context, state) {
          if (state is TrackingNumberScanSuccess) {
            globals.trackingNumber = state.barCode;
            trackingNumberController.text = globals.trackingNumber;
            trackingNumberController.selection = TextSelection.fromPosition(TextPosition(offset: trackingNumberController.text.length));
          }

          if (state is PickUpExternalSaved) {
            globals.trackingNumber = "";
            Toast.show(state.message, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            globals.selectedPickUpExternal = null;
            Navigator.pop(context, "saved");
          }

          if (state is AddToListExternalSuccess) {
            resetValues();
            Navigator.pop(context, "Saved");
          }

          if (state is PackageDetailsResponseFetchSuccess) {
            var packageDetailsResponse = state.packageDetailsResponse;
            //check from the package details for destination validation
            _sendPickUpToDb(packageDetailsResponse);
          }

          if (state is PackageDetailsResponseFetchFailure) {
            _sendPickUpToDb(null);
          }

          if (state is ScanOptionFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is PickUpApiCallLoading || state is DeliverySiteApiCallLoading || state is TransactionLoading) {
            _isLoading = true;
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceIdValue = state.deviceId;
            createExternalPickUpBloc.dispatch(FetchUserName());
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            _savePickUpExternalToDb();
          }

          if (state is PickUpSiteResponseFetchSuccess) {
            _isLoading = false;
            _pickUpSiteList.clear();
            _pickUpSiteList.addAll(state.locationResponse);

            if (pickUpExternal != null) {
              for (int i = 0; i < _pickUpSiteList.length; i++) {
                if (_pickUpSiteList[i].code == pickUpExternal.pickUpSite) {
                  _selectedPickUpSiteIndex = i;
                }
              }
            }

            final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _selectedPickUpSiteIndex);
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _BottomPicker(
                  child: CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: _kPickerItemHeight,
                    backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                    onSelectedItemChanged: (int index) {
                      setState(() => _selectedPickUpSiteIndex = index);
                    },
                    children: List<Widget>.generate(_pickUpSiteList.length, (int index) {
                      return Center(
                        child: Text(_pickUpSiteList[index].code),
                      );
                    }),
                  ),
                );
              },
            );
          }

          if (state is DeliverySiteResponseFetchSuccess) {
            _isLoading = false;
            _deliverySiteList.clear();
            _deliverySiteList.addAll(state.locationResponse);

            if (pickUpExternal != null) {
              for (int i = 0; i < _deliverySiteList.length; i++) {
                if (_deliverySiteList[i].code == pickUpExternal.deliverySite) {
                  _selectedDeliverySiteIndex = i;
                }
              }
            }

            final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _selectedDeliverySiteIndex);
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _BottomPicker(
                  child: CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: _kPickerItemHeight,
                    backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                    onSelectedItemChanged: (int index) {
                      setState(() => _selectedDeliverySiteIndex = index);
                    },
                    children: List<Widget>.generate(_deliverySiteList.length, (int index) {
                      return Center(
                        child: Text(_deliverySiteList[index].code),
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
        },
        child: BlocBuilder<CreatePickUpBloc, CreatePickUpState>(
            bloc: createExternalPickUpBloc,
            builder: (
              BuildContext context,
              CreatePickUpState state,
            ) {
              return getCupertinoScaffold(state, createExternalPickUpBloc);
            }));
  }

  bool _validateForm() {
    if (pickUpExternal == null && _selectedPickUpSiteIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_PICKUP_SITE, null);
      return false;
    }
    if (pickUpExternal == null && _selectedDeliverySiteIndex == -1) {
      showAlertDialog(context, Strings.PLEASE_PICK_DELIVERY_SITE, null);
      return false;
    }

    return _formKey.currentState.validate();
  }

  void resetValues() {
    globals.trackingNumber = "";
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
