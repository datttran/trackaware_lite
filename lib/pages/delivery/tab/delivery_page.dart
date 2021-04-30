import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/delivery_bloc.dart';
import 'package:trackaware_lite/events/delivery_event.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/states/delivery_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/main.dart';
import 'package:trackaware_lite/pages/landing/landing.dart' as landing;
import 'package:trackaware_lite/blocs/landing_page_bloc.dart' ;
//import 'package:trackaware_lite/events/landing_page_event.dart';

class DeliveryPage extends StatefulWidget {


  @override
  State<DeliveryPage> createState() {
    return DeliveryPageState();
  }
}

var deliveryBloc;
var _isLoading = false;
bool _showMsg = true;
List<LocationResponse> locationList = [];
int selectedLocationIndex = 0;

const double _kPickerItemHeight = 32.0;
const double _kPickerSheetHeight = 216.0;
List pickUpItems = [];

class DeliveryPageState extends State<DeliveryPage> {

  LandingPageBloc _landingPageBloc;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deliveryBloc = BlocProvider.of<DeliveryBloc>(context);

    if (globals.refreshDelivery) {
      globals.refreshDelivery = false;
      locationList.clear();
      deliveryBloc.dispatch(FetchDestinationList(location: ""));
    }

    Widget getNextButton() {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 26),
          child: Container(
              width: double.infinity,
              child: RaisedButton(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(16),
                  child: Text(Strings.NEXT,
                      style: TextStyle(color: HexColor(ColorStrings.SEND_BUTTON_TEXT_COLOR), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 16.0),
                      textAlign: TextAlign.center),
                  onPressed: () {

                    deliveryBloc.dispatch(NextButtonClick());
                  },
                  color: const Color(0xff424e53))));
    }

    Widget getPickUpList() {
      return Padding(
          padding: globals.showNextButton ? EdgeInsets.fromLTRB(16, 72.0, 16, 60) : EdgeInsets.fromLTRB(16, 72.0, 16, 0),
          child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                shrinkWrap: false,
                itemBuilder: (context, position) {
                  return GestureDetector(
                      onTap: () {
                        globals.barCode = pickUpItems[position].trackingNumber.split(':')[0] ;
                        print(globals.barCode);




                        if(pickUpItems[position].isScanned == 1){
                          setState(() {
                            pickUpItems[position].isScanned = 0;
                            globals.showNextButton = false;


                          });

                        }
                        else{
                          setState(() {
                            pickUpItems[position].isScanned = 1;

                            globals.showNextButton = true;



                          });




                        }





/*                        showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context, scrollController) {
                              var pickUpItem = pickUpItems[position];
                              var map = Map<String, String>();
                              map.putIfAbsent(Strings.PICK_UP_SITE, () => pickUpItem.pickUpSite);
                              map.putIfAbsent(Strings.DELIVERY_SITE, () => pickUpItem.deliverySite);
                              map.putIfAbsent(Strings.TRACKING_NUMBER, () => pickUpItem.trackingNumber);
                              return getDataListWidget(map);
                            },
                            isDismissible: true);*/
                      },
                      child: Card(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Container(
                            height: 120,
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
                                Row(
                                  mainAxisAlignment: pickUpItems[position].isScanned == 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 0.0),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("# Tracking Number",
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                        color: const Color(0xff767272), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 13.0)))),
                                        Container(
                                            padding: EdgeInsets.fromLTRB(20.0, 2.0, 0.0, 0.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                  padding: EdgeInsets.fromLTRB(0.0, 2.0, 20.0, 7.0),
                                                  child: Text(pickUpItems[position].trackingNumber,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.right,
                                                      style: const TextStyle(
                                                          color: const Color(0xff000000), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 18.0))),
                                            ))
                                      ]),
                                      flex: 1,
                                    ),
                                    Flexible(
                                        child: Visibility(
                                            visible: pickUpItems[position].isScanned == 1,
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: SvgPicture.asset(
                                                    "assets/ic_check_complete.svg",
                                                    semanticsLabel: "location icon",
                                                  ),
                                                ))),
                                        flex: 1)
                                  ],
                                ),
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
                                            Text(pickUpItems[position].deliverySite,
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
              )));
    }

    Widget _buildLocationPicker(BuildContext context) {
      return Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: new Material(
              color: Colors.transparent,
              child: locationList.isEmpty
                  ? Text("Pick location" , style: TextStyle(color: Color(0xff35357a).withOpacity(.5)),)
                  : Text(
                      locationList[selectedLocationIndex].code,
                      style: TextStyle(color: CupertinoDynamicColor.resolve( Color(0xff35357a).withOpacity(.5), context)),
                    )));
    }

    Widget getDropDownWidget() {
      return GestureDetector(
          onTap: () {
            deliveryBloc.dispatch(FetchLocation());
          },
          child: Container(
              margin: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0.0),
              padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              width: double.infinity,
              decoration: new BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xffdac2ff).withOpacity(.4),
                        Color(0xffdac2ff).withOpacity(.6)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1]
                  ),
                  borderRadius: new BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildLocationPicker(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 8.0, 0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color:   Color(0xff35357a).withOpacity(.5),
                      size: 36.0,
                    ),
                  ),
                ],
              )));
    }

    Widget getCupertinoScaffold(DeliveryState state, DeliveryBloc deliveryBloc) {
      return Container(
          child: Stack(children: <Widget>[
        ListView(
          children: <Widget>[
            SizedBox(height: 15,),
            getDropDownWidget(),





            Padding(padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0), child: Divider(thickness: 1.0, color: const Color(0xff979797))),
          ],
        ),
        pickUpItems.isNotEmpty ? getPickUpList() : Text(""),
        Align(
          child: _isLoading
              ? CupertinoActivityIndicator(
                  animating: true,
                  radius: 20.0,
                )
              : Text(""),
          alignment: AlignmentDirectional.center,
        ),
        pickUpItems.isEmpty
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 70),
                    height: 150,
                    color: Colors.transparent,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      SvgPicture.asset(

                        "assets/ic_box.svg",
                        semanticsLabel: "empty icon",
                        height: 100,
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Text(
                            Strings.NO_PICKUP_ITEMS_FOR_DELIVERY,
                            style: TextStyle(fontSize: 20.0, color: Color(0xffeaeaff).withOpacity(.6)),
                          ))
                    ])))
            : Text(""),
        Align(
          child: Visibility(visible: globals.showNextButton, child: getNextButton()),
          alignment: AlignmentDirectional.bottomCenter,
        )
      ]));
    }

    return BlocListener<DeliveryBloc, DeliveryState>(
        listener: (context, state) async {
          if (state is LocationResponseFetchSuccess) {
            _isLoading = false;
            locationList.clear();
            var _locationResponse = LocationResponse();
            _locationResponse.code = "Pick Location";
            locationList.add(_locationResponse);
            locationList.addAll(state.locationResponse);

            final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: selectedLocationIndex);
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _BottomPicker(
                  child: CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: _kPickerItemHeight,
                    backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                    onSelectedItemChanged: (int index) {
                      selectedLocationIndex = index;
                      deliveryBloc.dispatch(FetchDestinationList(location: locationList[selectedLocationIndex].code));
                    },
                    children: List<Widget>.generate(locationList.length, (int index) {
                      return Center(
                        child: Text(locationList[index].code),
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

          if (state is ShowHideMsgBlock) {
            _showMsg = state.showMsg;
          }

          if (state is LocationApiCallLoading || state is Loading) {
            _isLoading = true;
          }

          if (state is DestinationListFetchSuccess) {
            _isLoading = false;
            pickUpItems.clear();
            pickUpItems.addAll(state.pickUpResponse);

            int count = 0;
            pickUpItems.forEach((element) {
              if (element.isScanned == 1) {
                count++;
              }
            });

            _showMsg = pickUpItems.isNotEmpty;

            if (_showMsg) {
              Toast.show("Scan Package for delivery", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }

            globals.showNextButton = count > 0;
            deliveryBloc.dispatch(ResetEvent());
          }

          if (state is DestinationListFetchFailure) {
            _isLoading = false;
            globals.showNextButton = false;
            pickUpItems.clear();
          }

          if (state is NextButtonClickSuccess) {
            globals.selectedLoc = locationList[selectedLocationIndex].code;
            final result = await Navigator.of(context).pushNamed('/Signature');
            if (result?.toString()?.isNotEmpty == true) {
              locationList.clear();
              selectedLocationIndex = 0;
              deliveryBloc?.dispatch(FetchDestinationList(location: ""));
            }
          }
        },
        child: BlocBuilder<DeliveryBloc, DeliveryState>(
            bloc: deliveryBloc,
            builder: (
              BuildContext context,
              DeliveryState state,
            ) {
              return getCupertinoScaffold(state, deliveryBloc);
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
