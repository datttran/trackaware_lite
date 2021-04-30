import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_icons/flutter_icons.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:trackaware_lite/blocs/landing_page_bloc.dart';
import 'package:trackaware_lite/events/delivery_event.dart';
import 'package:trackaware_lite/events/landing_page_event.dart';
import 'package:trackaware_lite/models/arrive_db.dart';
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/depart_db.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';
import 'package:trackaware_lite/pages/landing/landingappbar.dart';
import 'package:trackaware_lite/pages/delivery/tab/delivery_page.dart';
import 'package:trackaware_lite/pages/landing/tabwidgets/arrive_tab_widget.dart';
import 'package:trackaware_lite/pages/landing/tabwidgets/deliver_tab_widget.dart';
import 'package:trackaware_lite/pages/landing/tabwidgets/depart_tab_widget.dart';
import 'package:trackaware_lite/pages/landing/tabwidgets/pickup_tab_widget.dart';
import 'package:trackaware_lite/pages/landing/tabwidgets/tender_tab_widget.dart';
import 'package:trackaware_lite/pages/tender/external/add/create_external_tender_parts.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';
import 'package:trackaware_lite/repositories/external_tender_repository.dart';
import 'package:trackaware_lite/repositories/landing_page_repository.dart';
import 'package:trackaware_lite/responsive/size_config.dart';
import 'package:trackaware_lite/states/landing_page_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart'; // ignore: unused_import
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/utils/utils.dart'; // ignore: unused_import
import 'package:trackaware_lite/globals.dart' as globals;

List<TenderExternal> _tenderListItems = <TenderExternal>[];
List<TenderParts> _tenderPartsListItems = <TenderParts>[];
List<Arrive> _arriveItems = <Arrive>[];
List<Depart> _departItems = <Depart>[];

List<TransactionRequest> _transactionRequestItems = <TransactionRequest>[];
List<DeliveryRequest> _delieryRequestItems = <DeliveryRequest>[];

String _userName;
String _token;
bool _isLoading = false;
bool _isImageLoaded = false;
int transactionCount = 0;
int deliveryCount = 0;
var deviceIdValue;
File _imageFile;
bool _displayScan = false;

class LandingPage extends StatefulWidget {
  final LandingPageApiRepository landingPageApiRepository;
  final TenderApiRepository externalTenderApiRepository;
  final DeliveryApiRepository deliveryApiRepository;





  LandingPage(
      {Key key,
      @required this.landingPageApiRepository,
      @required this.externalTenderApiRepository,
      @required this.deliveryApiRepository,


      })
      : assert(landingPageApiRepository != null),
        super(key: key);


  @override
  State<StatefulWidget> createState() => new _LandingPageState(
      landingPageApiRepository: landingPageApiRepository,
      externalTenderApiRepository: externalTenderApiRepository,
      deliveryApiRepository: deliveryApiRepository);
}

class _LandingPageState extends  State<LandingPage> with SingleTickerProviderStateMixin{
  final LandingPageApiRepository landingPageApiRepository;
  final TenderApiRepository externalTenderApiRepository;
  final DeliveryApiRepository deliveryApiRepository;













  LandingPageBloc _landingPageBloc;

  _LandingPageState(
      {@required this.landingPageApiRepository,
      @required this.externalTenderApiRepository,
      @required this.deliveryApiRepository,


      });



  final List<Tab> driverModeTabs = <Tab>[
    new Tab(text: Strings.pickUpTitle),
    new Tab(text: Strings.deliveryTitle),

  ];

  final List<Tab> tenderModeTabs = <Tab>[

    new Tab(text: Strings.pickUpTitle),
    new Tab(text: Strings.deliveryTitle),

  ];

  List<Widget> driverWidgets;

  List<Widget> tenderWidgets;
  TabController _tabController;

  Location location = new Location();
  StreamSubscription<LocationData> _locationSubscription;
  bool isPermissionEnabled = false;




  @override
  void initState() {






    _tabController = getTabController();
    if (globals.isDriverMode)
      _tabController.addListener(_handleDriverTabSelection);
    else
      _tabController.addListener(_handleTenderTabSelection);



    driverWidgets = <Widget>[
      PickUpTabWidget(),
      DeliveryTabWidget(
        deliveryApiRepository: deliveryApiRepository,
      ),

    ];

    tenderWidgets = <Widget>[

      PickUpTabWidget(),
      DeliveryTabWidget(
        deliveryApiRepository: deliveryApiRepository,
      ),

    ];
    super.initState();


    //scanner

  }




  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();


  }

  Widget getTrackAwareScaffold(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
        builder: (context) {
          return LandingPageBloc(
            landingPageApiRepository: landingPageApiRepository,
          );
        },
        child: BlocListener<LandingPageBloc, LandingPageState>(
            listener: (context, state) async {
              if (state is ShowScan) {
                _displayScan = true;
              }

              if (state is HideScan) {
                _displayScan = false;
              }

              if (state is PermissionStatusResult) {
                isPermissionEnabled = state.isPermissionEnabled;
                if (isPermissionEnabled) {
                  _landingPageBloc
                      .dispatch(CheckLocationService(location: location));
                }
              }

              if (state is LocationServiceStatus) {
                var isLocationServiceEnabled = state.isLocationServiceEnabled;
                if (isLocationServiceEnabled) {
                  _landingPageBloc.dispatch(FetchLocationValues());
                }
              }

              if (state is FetchDeviceIdSuccess) {
                deviceIdValue = state.deviceId;
              }

              if (state is FetchLocationSuccess) {
                var locationList = state.locationList;
                if (locationList.isNotEmpty) {
                  var gpsPollInterval =
                      locationList[locationList.length - 1].gpsPollInterval;
                  _landingPageBloc.dispatch(ChangeLocationFetchInterval(
                      interval: gpsPollInterval, location: location));
                }
              }

              if (state is LocationSettingsChangeSuccess) {
                _locationSubscription =
                    location.onLocationChanged.handleError((dynamic err) {
                  _locationSubscription.cancel();
                }).listen((LocationData currentLocation) {
                  //todo - implement post interval from settings
                  var locationRequest = getLocationRequest(
                      currentLocation, deviceIdValue, _userName);
                  _landingPageBloc
                      .dispatch(PeriodicLocationUpdate(locationRequest));
                  print(currentLocation);
                });
              }

              if (state is ScanSuccess) {
                switch (globals.selectedTabIndex) {
                  case 0:
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => CreateExternalTenderParts(
                            tenderApiRepository: externalTenderApiRepository),
                        // Pass the arguments as part of the RouteSettings. The
                        // DetailScreen reads the arguments from these settings.
                        settings: RouteSettings(
                          arguments: state.barCode,
                        ),
                      ),
                    );
                    break;
                  case 2:
                    globals.barCode = state.barCode;
                    checkForTrackNumOnDelivery(state.barCode);
                    break;
                  default:
                }
              }

              if (state is TransactionLoading || state is DeliveryLoading) {
                _isLoading = true;
              }

              if (state is SyncLoading) {
                _isLoading = true;
                Toast.show("Syncing", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }

              if (state is ScanFailure) {
                print(state.error);
              }

              if (state is TenderTransactionRequestSuccess) {
                if (transactionCount != 0 &&
                    transactionCount == _transactionRequestItems.length) {
                  transactionCount = 0;
                  _isLoading = false;
                  print(state.message);
                } else {
                  _isLoading = false;
                }
              }

              if (state is DeliveryRequestSuccess) {
                if (deliveryCount != 0 &&
                    deliveryCount == _delieryRequestItems.length) {
                  deliveryCount = 0;
                  _isLoading = false;
                  print(state.message);
                } else {
                  _isLoading = false;
                }
              }

              if (state is TenderTransactionRequestFailure) {
                _isLoading = false;
                print(state.error);
              }

              if (state is ExternalTenderListFetchSuccess) {
                _tenderListItems.clear();
                _tenderListItems.addAll(state.tenderExternalResponse);

                if (_tenderListItems.isNotEmpty) {
                  _generateTransactionRequest();
                  if (_transactionRequestItems.isNotEmpty) {
                    for (var i = 0; i < _transactionRequestItems.length; i++) {
                      transactionCount += 1;
                      _landingPageBloc.dispatch(SyncButtonClick(
                          transactionRequests: _transactionRequestItems[i],
                          transactionRequestCount: 0));
                    }
                  } else {
                    print("No transactions to be synced");
                  }
                }
              }

              if (state is TenderPartsListFetchSuccess) {
                _tenderPartsListItems.clear();
                _tenderPartsListItems.addAll(state.tenderPartsResponse);

                if (_tenderPartsListItems
                    .isNotEmpty /*  && _userName!=null && _userName.isNotEmpty */) {
                  _generateTransactionRequest();
                  if (_transactionRequestItems.isNotEmpty) {
                    for (var i = 0; i < _transactionRequestItems.length; i++) {
                      transactionCount += 1;
                      _landingPageBloc.dispatch(SyncButtonClick(
                          transactionRequests: _transactionRequestItems[i],
                          transactionRequestCount: 0));
                    }
                  } else {
                    print("No transactions to be synced");
                  }
                }
              }

              if (state is ArriveListItemsFetchSuccess) {
                _arriveItems.clear();
                _arriveItems.addAll(state.arriveResponse);

                if (_arriveItems.isNotEmpty) {
                  _generateDeliveryItems();
                  if (_delieryRequestItems.isNotEmpty) {
                    for (var i = 0; i < _delieryRequestItems.length; i++) {
                      deliveryCount += 1;
                      _landingPageBloc.dispatch(SyncDeliveryItems(
                          deliveryRequest: _delieryRequestItems[i],
                          deliveryRequestCount: 0));
                    }
                  } else {
                    print("No transactions to be synced");
                  }
                }
              }

              if (state is DepartListItemsFetchSuccess) {
                _departItems.clear();
                _departItems.addAll(state.departResponse);

                if (_departItems.isNotEmpty) {
                  _generateDeliveryItems();
                  if (_delieryRequestItems.isNotEmpty) {
                    for (var i = 0; i < _delieryRequestItems.length; i++) {
                      deliveryCount += 1;
                      _landingPageBloc.dispatch(SyncDeliveryItems(
                          deliveryRequest: _delieryRequestItems[i],
                          deliveryRequestCount: 0));
                    }
                  } else {
                    print("No transactions to be synced");
                  }
                }
                _isLoading = false;
                _landingPageBloc.dispatch(PriorityFetch());
                _landingPageBloc.dispatch(LocationFetch());
              }

              if (state is DepartListItemsFetchFailure) {
                _isLoading = false;
                _landingPageBloc.dispatch(PriorityFetch());
                _landingPageBloc.dispatch(LocationFetch());
              }

              if (state is UserNameFetchSuccess) {
                _userName = state.userName;
                _token = state.token;
                _landingPageBloc.dispatch(
                    FetchUserProfileImage(userName: _userName, token: _token));
                _landingPageBloc.dispatch(FetchSettings(userName: _userName));
              }

              if (state is ProfileImageClickActionSuccess) {
                Navigator.of(context).pushNamed('/Profile');
              }

              if (state is UpdatePickUpItemSuccess) {
                deliveryBloc.dispatch(FetchDestinationList(
                    location: locationList[selectedLocationIndex].code));
              }

              if (state is FetchUserProfileImageSuccess) {
                var response = state.response;
                Directory tempDir = await getTemporaryDirectory();
                String tempPath = tempDir.path;
                _imageFile = new File('$tempPath/user_profile.png');
                _imageFile.writeAsBytes(response.bodyBytes).then((value) {
                  _isLoading = false;
                  _isImageLoaded = true;
                  // _landingPageBloc.dispatch(ResetEvent());
                });
              }

              if (state is ResetState) {}
            },
            child: BlocBuilder<LandingPageBloc, LandingPageState>(
                bloc: _landingPageBloc,
                builder: (
                  BuildContext context,
                  LandingPageState state,
                ) {

                  if (_landingPageBloc == null)
                    _landingPageBloc =
                        BlocProvider.of<LandingPageBloc>(context);

                  if (!isPermissionEnabled) {
                    _landingPageBloc.dispatch(FetchUserName());
                    _landingPageBloc.dispatch(FetchDeviceId());
                    _landingPageBloc
                        .dispatch(CheckLocationPermission(location: location));
                    _landingPageBloc.dispatch(PriorityFetch());
                    _landingPageBloc.dispatch(LocationFetch());
                  }

                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xff171721),
                          /*image: DecorationImage(
                            image: AssetImage('images/bg7.png'),

                            //4.7.10 look nice
                            fit: BoxFit.fill

                          )*/
                        ),
                      ),

                      Scaffold(
                        backgroundColor: Colors.transparent,

                          appBar: LandingAppBarImage(
                              Icon(EvilIcons.user, size: 10,color: Colors.white,),
                              Icon(EvilIcons.navicon, size: 30,color: Color(0xff7e7eff),),
                              _tabController),
                          resizeToAvoidBottomInset: false,
                          body: RawKeyboardListener(
                            autofocus: true,
                            focusNode: FocusNode(),
                            onKey: (RawKeyEvent event){

                              if (event.runtimeType.toString() == 'RawKeyDownEvent') {

                                checkForTrackNumOnDelivery(globals.barCode);



                              }
                            },
                            child: Container(
                                color: Color(0xfff0ccff).withOpacity(0),
                                child: Stack(children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),


                                          child: GestureDetector(
                                            onDoubleTap: (){
                                              checkForTrackNumOnDelivery(globals.barCode);
                                            },
                                            child: new TabBarView(
                                              controller: _tabController,
                                              children: globals.isDriverMode
                                                  ? driverWidgets
                                                  : tenderWidgets,
                                            ),
                                          ),
                                        ),
                                        flex: globals.isDriverMode ? 2 : 2,
                                      ),
                                      /* Flexible(
                                      child:  */

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
                                  )
                                ])),
                          )),

                    ],
                  );
                })));
  }

  void _handleTenderTabSelection() {
    switch (_tabController.index) {
/*      case 0:
        globals.selectedTabIndex = _tabController.index;
        TenderTabWidget();
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: false));
        break;*/
      case 0:
        globals.selectedTabIndex = _tabController.index;
        PickUpTabWidget();
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: false));
        break;
      case 1:
        globals.selectedTabIndex = _tabController.index;
        DeliveryTabWidget(
          deliveryApiRepository: deliveryApiRepository,
        );
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: true));
        break;
/*      case 3:
        globals.selectedTabIndex = _tabController.index;
        ArriveTabWidget();
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: false));
        break;
      case 4:
        globals.selectedTabIndex = _tabController.index;
        DepartTabWidget();
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: false));
        break;*/
    }

    print("Changed tab to: $_tabController.index");
  }

  void _handleDriverTabSelection() {
    switch (_tabController.index) {
      case 0:
        globals.selectedTabIndex = _tabController.index;
        PickUpTabWidget();
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: false));
        break;
      case 1:
        globals.selectedTabIndex = _tabController.index;
        DeliveryTabWidget(
          deliveryApiRepository: deliveryApiRepository,
        );
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: true));
        break;
      /*case 2:
        globals.selectedTabIndex = _tabController.index;
        ArriveTabWidget();
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: false));
        break;
      case 3:
        globals.selectedTabIndex = _tabController.index;
        DepartTabWidget();
        _landingPageBloc.dispatch(ScanImageEvent(displayScanImage: false));
        break;*/
    }

    print("Changed tab to: $_tabController.index");
  }

  @override
  Widget build(BuildContext context) {
    return getTrackAwareScaffold(context);
  }

  _generateTransactionRequest() {
    _tenderListItems.forEach((_generateTransactionList));
    _tenderPartsListItems.forEach((_generateTransactionListFromTenderParts));
  }

  _generateDeliveryItems() {
    _arriveItems.forEach((_generateDeliveryList));
    _departItems.forEach((_generateDeliveryListFromDepartItem));
  }

  _generateDeliveryList(Arrive arrive) {
    if (arrive.isSynced == 0) {
      DeliveryRequest deliveryRequest = new DeliveryRequest();
      deliveryRequest.handHeldId = deviceIdValue;
      deliveryRequest.id = arrive.id;
      deliveryRequest.user = _userName;
      deliveryRequest.location = arrive.location;
      deliveryRequest.status = Strings.ARRIVE_LOWERCASE;
      deliveryRequest.scanTime = arrive.scanTime.toString();
      _delieryRequestItems.add(deliveryRequest);
    }
  }

  _generateDeliveryListFromDepartItem(Depart depart) {
    if (depart.isSynced == 0) {
      DeliveryRequest deliveryRequest = new DeliveryRequest();
      deliveryRequest.handHeldId = deviceIdValue;
      deliveryRequest.id = depart.id;
      deliveryRequest.user = _userName;
      deliveryRequest.location = depart.location;
      deliveryRequest.status = Strings.DEPART_LOWERCASE;
      deliveryRequest.scanTime = depart.scanTime.toString();
      _delieryRequestItems.add(deliveryRequest);
    }
  }

  _generateTransactionList(TenderExternal tenderExternal) {
    if (tenderExternal.isSynced == 0) {
      TransactionRequest transactionRequest = TransactionRequest();

      transactionRequest.handHeldId = deviceIdValue;
      transactionRequest.id = tenderExternal.id;
      transactionRequest.location = tenderExternal.location;
      transactionRequest.status = Strings.TENDER;
      transactionRequest.user = _userName;
      // transactionRequest.user = "rr0055256";
      transactionRequest.packages = [getPackage(tenderExternal)];
      _transactionRequestItems.add(transactionRequest);
    }
  }

  _generateTransactionListFromTenderParts(TenderParts tenderParts) {
    if (tenderParts.isSynced == 0) {
      TransactionRequest transactionRequest = TransactionRequest();

      transactionRequest.handHeldId = deviceIdValue;
      transactionRequest.id = tenderParts.id;
      transactionRequest.location = tenderParts.location;
      transactionRequest.status = Strings.TENDER;
      transactionRequest.user = _userName;
      // transactionRequest.user = "rr0055256";
      transactionRequest.packages = [getPackageFromTenderPart(tenderParts)];
      _transactionRequestItems.add(transactionRequest);
    }
  }

  TabController getTabController() {
    if (globals.isDriverMode)
      return new TabController(vsync: this, length: driverModeTabs.length);
    else
      return new TabController(vsync: this, length: tenderModeTabs.length);
  }

  void checkForTrackNumOnDelivery(String barCode) {
    print("Bar code : $barCode");
    print('barCode checked');

    if (pickUpItems.isNotEmpty) {
      pickUpItems.forEach((element) {
        print('this is element');
        print(element.trackingNumber);
        print(element.toString());
        print(globals.selectedLoc);
        print('end');
        if( element.isScanned == 0){
          if (element.trackingNumber.contains(barCode)  ) {
            element.isScanned = 1;

            _landingPageBloc.dispatch(UpdatePickUpItem(pickUpExternal: element));
          }


        }





      });
    }
  }






}

