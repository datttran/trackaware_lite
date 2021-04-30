import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/display_bloc.dart';
import 'package:trackaware_lite/events/display_event.dart';
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/states/display_event.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class DisplayPage extends StatefulWidget {
  final String keyName;
  final String displayName;
  DisplayPage({@required this.keyName, @required this.displayName});
  @override
  State<DisplayPage> createState() {
    return _DisplayPageConfigState(keyName: keyName, displayName: displayName);
  }
}

final displayNameController = TextEditingController();

final FocusNode displayNameFocus = FocusNode();

bool _isLoading = false;
var displayConfigBloc;

class _DisplayPageConfigState extends State<DisplayPage> {
  final String keyName;
  final String displayName;
  final _formKey = GlobalKey<FormState>();
  List<DisciplineConfigResponse> disciplineConfigValues = List();

  _DisplayPageConfigState({@required this.keyName, @required this.displayName});
  @override
  void dispose() {
    displayNameController.clear();
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displayConfigBloc = BlocProvider.of<DisplayConfigBloc>(context);

    if (disciplineConfigValues.isEmpty) {
      displayConfigBloc.dispatch(FetchDisplayConfig(keyName: keyName));
    }

    _saveDepartItemToDb() {
      if (_formKey.currentState.validate()) {
        displayConfigBloc.dispatch(SaveDisplayConfigEvent(
            keyName: keyName,
            disciplineConfigValue: displayNameController.text));
      }
    }

    Widget getSaveButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 26),
          child: Container(
              width: double.infinity,
              child: RaisedButton(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16),
                  child: Text(Strings.SAVE,
                      style: TextStyle(
                          color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR),
                          fontWeight: FontWeight.w400,
                          fontFamily: "SourceSansPro",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center),
                  onPressed: () {
                    _saveDepartItemToDb();
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getDisplayNameWidget() {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: HexColor(ColorStrings.BORDER),
              ),
              color: Colors.white),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(14, 16, 10, 0),
                    child: Material(
                        color: Colors.transparent,
                        child: Text(
                          Strings.DISPLAY_NAME,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: HexColor(ColorStrings.HEADING),
                              fontFamily: "SourceSansPro",
                              fontSize: 12.0,
                              fontStyle: FontStyle.normal),
                        ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(14, 10, 10, 16),
                    child: new Material(
                        color: Colors.transparent,
                        child: new TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                              color: HexColor(ColorStrings.VALUES),
                              fontSize: 16),
                          autofocus: true,
                          decoration: InputDecoration.collapsed(
                              focusColor:
                                  HexColor(ColorStrings.emailPwdTextColor),
                              hintText: Strings.ENTER_DISPLAY_NAME),
                          validator: (value) {
                            if (value.isEmpty) {
                              return Strings.DISPLAY_NAME_EMPTY_VALIDATION_MSG;
                            }
                            return null;
                          },
                          controller: displayNameController,
                          textInputAction: TextInputAction.done,
                          focusNode: displayNameFocus,
                          onFieldSubmitted: (v) {
                            displayNameFocus.unfocus();
                          },
                        )))
              ]));
    }

    Widget getScaffold() {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              backgroundColor:
                  HexColor(ColorStrings.boxBackground).withAlpha(30),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // navigateTo();
                },
                child: Row(
                  children: <Widget>[Image.asset("images/ic_back.png")],
                ),
              ),
              middle: Text(displayName)),
          child: Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(
                      color:
                          HexColor(ColorStrings.boxBackground).withAlpha(30)),
                  child: Stack(children: <Widget>[
                    ListView(
                      children: <Widget>[
                        getDisplayNameWidget(),
                      ],
                    ),
                    Align(
                      child: getSaveButton(),
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

    Widget getCupertinoScaffold(
        DisplayConfigState state, DisplayConfigBloc displayConfigBloc) {
      return Platform.isAndroid
          ? WillPopScope(
              onWillPop: () {
                // navigateTo();
                Navigator.pop(context);
                return;
              },
              child: getScaffold())
          : getScaffold();
    }

    return BlocListener<DisplayConfigBloc, DisplayConfigState>(
        listener: (context, state) {
          if (state is SaveDisplayConfigSuccess) {
            // navigateTo();
            Navigator.pop(context);
          }

          if (state is FetchDisplayConfigSuccess) {
            disciplineConfigValues.addAll(state.disciplineConfigValues);
            displayNameController.text =
                disciplineConfigValues?.elementAt(0)?.displayName;
            displayNameController.selection = TextSelection.fromPosition(
                TextPosition(offset: displayNameController.text.length));
          }
        },
        child: BlocBuilder<DisplayConfigBloc, DisplayConfigState>(
            bloc: displayConfigBloc,
            builder: (
              BuildContext context,
              DisplayConfigState state,
            ) {
              return getCupertinoScaffold(state, displayConfigBloc);
            }));
  }

  void navigateTo() {
    switch (keyName) {
      case Strings.TENDER_PRODUCTION_PARTS_KEY:
        {
          Navigator.of(context).pushNamed('/TenderConfig');
        }
        break;
      case Strings.TENDER_EXTERNAL_PACKAGES_KEY:
        {
          Navigator.of(context).pushNamed('/TenderConfig');
        }
        break;
      case Strings.PICKUP_PRODUCTION_PARTS_KEY:
        {
          Navigator.of(context).pushNamed('/PickUpConfig');
        }
        break;
      case Strings.PICKUP_EXTERNAL_PACKAGES_KEY:
        {
          Navigator.of(context).pushNamed('/PickUpConfig');
        }
        break;
      default:
        Navigator.of(context).pushNamed('/DeliveryConfig');
    }
  }
}
