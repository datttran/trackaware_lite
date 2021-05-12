import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/create_arrive_bloc.dart';
import 'package:trackaware_lite/events/create_arrive_event.dart';
import 'package:trackaware_lite/models/arrive_db.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/states/create_arrive_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart';

class CreateArriveForm extends StatefulWidget {
  @override
  State<CreateArriveForm> createState() {
    return _CreateArriveFormState();
  }
}

const double _kPickerItemHeight = 32.0;
const double _kPickerSheetHeight = 216.0;

List<LocationResponse> _locationList = List<LocationResponse>();

int _selectedLocationIndex = -1;
bool _isLoading = false;
var createArriveBloc;
String _deviceIdValue;
String _userName;

class _CreateArriveFormState extends State<CreateArriveForm> {
  @override
  void dispose() {
    _isLoading = false;
    _locationList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createArriveBloc = BlocProvider.of<CreateArriveBloc>(context);

    _saveArriveItemToDb() {
      if (_selectedLocationIndex == -1) {
        showAlertDialog(context, Strings.PLEASE_PICK_LOCATION, null);
      } else {
        createArriveBloc.dispatch(FetchDeviceId());
      }
    }

    Widget _buildLocationPicker(BuildContext context) {
      return GestureDetector(
          onTap: () {
            createArriveBloc.dispatch(LocationViewClick());
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

    Widget getSubmitButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 26),
          child: Container(
              width: double.infinity,
              child: RaisedButton(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16),
                  child: Text(Strings.SUBMIT,
                      style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
                  onPressed: () {
                    _saveArriveItemToDb();
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
              middle: Text(Strings.arriveTitle)),
          child: Container(
              decoration: BoxDecoration(color: HexColor(ColorStrings.boxBackground).withAlpha(30)),
              child: Stack(children: <Widget>[
                ListView(children: <Widget>[getLocationWidget()]),
                Align(child: getSubmitButton(), alignment: AlignmentDirectional.bottomCenter),
                Align(
                  child: _isLoading
                      ? CupertinoActivityIndicator(
                          animating: true,
                          radius: 20.0,
                        )
                      : Text(""),
                  alignment: AlignmentDirectional.center,
                ),
              ])));
    }

    Widget getCupertinoScaffold(CreateArriveState state, CreateArriveBloc createArriveBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<CreateArriveBloc, CreateArriveState>(
        listener: (context, state) {
          if (state is ArriveItemSaved) {
            Toast.show("Arrive entry created", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            Navigator.pop(context, "saved");
          }

          if (state is FetchDeviceIdSuccess) {
            _deviceIdValue = state.deviceId;
            createArriveBloc.dispatch(FetchUserName());
          }

          if (state is UserNameFetchSuccess) {
            _userName = state.userName;
            Arrive arrive = Arrive();
            arrive.location = _locationList[_selectedLocationIndex].code;
            arrive.scanTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
            arrive.isSynced = 1;
            createArriveBloc.dispatch(SubmitButtonClick(arrive, generateDeliveryList(arrive, _deviceIdValue, _userName)));
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

          if (state is ArriveItemFailure) {
            _isLoading = false;
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CreateArriveBloc, CreateArriveState>(
            bloc: createArriveBloc,
            builder: (
              BuildContext context,
              CreateArriveState state,
            ) {
              return getCupertinoScaffold(state, createArriveBloc);
            }));
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
