//username testtest / driver
//password testtest / driver

import 'package:bloc/bloc.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/api/delivery_api_client.dart';
import 'package:trackaware_lite/api/landing_page_api_client.dart';
import 'package:trackaware_lite/api/pickup_api_client.dart';
import 'package:trackaware_lite/api/profile_api_client.dart';
import 'package:trackaware_lite/api/settings_page_api_client.dart';
import 'package:trackaware_lite/api/signature_page_api_client.dart';
import 'package:trackaware_lite/pages/delivery/arrive/add/create_arrive.dart';
import 'package:trackaware_lite/pages/delivery/depart/add/create_depart.dart';
import 'package:trackaware_lite/pages/delivery/tab/delivery_page.dart';
import 'package:trackaware_lite/pages/delivery/tab/signature/signature.dart';
import 'package:trackaware_lite/pages/forgotpwd/forgot_pwd.dart';
import 'package:trackaware_lite/pages/landing/scan/scanoptions/scan_option.dart';
import 'package:trackaware_lite/pages/landing/scan/tenderpickup/tender_pickup_scan.dart';
import 'package:trackaware_lite/pages/pickup/external/add/create_external_pickup.dart';
import 'package:trackaware_lite/pages/pickup/external/list/pickup_external_page.dart';
import 'package:trackaware_lite/pages/pickup/part/add/create_pickup_part.dart';
import 'package:trackaware_lite/pages/pickup/part/list/pickup_parts_page.dart';
import 'package:trackaware_lite/pages/profile/profile.dart';
import 'package:trackaware_lite/pages/settings/location/location.dart';
import 'package:trackaware_lite/pages/settings/server/server.dart';
import 'package:trackaware_lite/pages/settings/settings.dart';
import 'package:trackaware_lite/pages/settings/tabs/delivery/delivery_config.dart';
import 'package:trackaware_lite/pages/settings/tabs/display/display.dart';
import 'package:trackaware_lite/pages/settings/tabs/pickup/pickup_config.dart';
import 'package:trackaware_lite/pages/settings/tabs/tabs_config.dart';
import 'package:trackaware_lite/pages/settings/tabs/tender/tender_config.dart';
import 'package:trackaware_lite/pages/signup/sign_up.dart';
import 'package:trackaware_lite/pages/tender/external/list/tenderexternalpackages.dart';
import 'package:trackaware_lite/pages/tender/parts/add/create_tender_parts.dart';
import 'package:trackaware_lite/pages/tender/parts/list/tender_parts.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';

import 'package:trackaware_lite/repositories/external_tender_repository.dart';
import 'package:trackaware_lite/repositories/landing_page_repository.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';
import 'package:trackaware_lite/repositories/profile_repository.dart';
import 'package:trackaware_lite/repositories/settings_repository.dart';
import 'package:trackaware_lite/repositories/signature_page_repository.dart';
import 'package:trackaware_lite/responsive/size_config.dart';

import 'api/external_tender_api_client.dart';
import 'api/user_login_api_client.dart';
import 'blocs/authentication_bloc.dart';
import 'events/authentication_event.dart';
import 'pages/landing/landing.dart';
import 'pages/login/login.dart';
import 'pages/splash.dart';
import 'pages/tender/external/add/create_external_tender_parts.dart';
import 'repositories/user_repository.dart';
import 'states/authentication_state.dart';
import 'utils/loading_indicator.dart';
import 'package:http/http.dart' as http;

import 'package:trackaware_lite/globals.dart' as globals;


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository =
  UserRespository(userApiClient: UserApiClient(httpClient: http.Client()));
  final externalTenderApiRepository = TenderApiRepository(
      externalTenderApiClient: TenderApiClient(httpClient: http.Client()));
  final landingPageRepository = LandingPageApiRepository(
      landingPageApiClient: LandingPageApiClient(httpClient: http.Client()));
  final pickUpApiRepository = PickUpApiRepository(
      pickUpApiClient: PickUpApiClient(httpClient: http.Client()));
  final deliveryApiRepository = DeliveryApiRepository(
      deliveryApiClient: DeliveryApiClient(httpClient: http.Client()));
  final profileRepository = ProfileRepository(
      profileApiClient: ProfileApiClient(httpClient: http.Client()));
  final signaturePageRepository = SignaturePageRepository(
      signatureApiClient: SignatureApiClient(httpClient: http.Client()));
  final settingsPageApiRepository = SettingsPageApiRepository(
      settingsPageApiClient: SettingsPageApiClient(httpClient: http.Client()));
  runApp(
    BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..dispatch(AppStarted());
      },
      child: MyApp(
        userRepository: userRepository,
        tenderApiRepository: externalTenderApiRepository,
        landingPageApiRepository: landingPageRepository,
        pickUpApiRepository: pickUpApiRepository,
        deliveryApiRepository: deliveryApiRepository,
        profileRepository: profileRepository,
        signaturePageRepository: signaturePageRepository,
        settingsPageApiRepository: settingsPageApiRepository,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final UserRespository userRepository;
  final TenderApiRepository tenderApiRepository;
  final LandingPageApiRepository landingPageApiRepository;
  final PickUpApiRepository pickUpApiRepository;
  final DeliveryApiRepository deliveryApiRepository;
  final ProfileRepository profileRepository;
  final SignaturePageRepository signaturePageRepository;
  final SettingsPageApiRepository settingsPageApiRepository;

  MyApp(
      {Key key,
        @required this.userRepository,
        @required this.tenderApiRepository,
        @required this.landingPageApiRepository,
        @required this.pickUpApiRepository,
        @required this.deliveryApiRepository,
        @required this.profileRepository,
        @required this.signaturePageRepository,
        @required this.settingsPageApiRepository})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {


  bool scannerEnabled = true;
  bool scan1DFormats = true;
  bool scan2DFormats = true;



  String orderNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }



  @override

  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
            SystemChrome.restoreSystemUIOverlays();
          }
        },
        child: BackGestureWidthTheme(
            backGestureWidth: BackGestureWidth.fraction(1 / 2),
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,


                    unselectedWidgetColor: Colors.white70.withOpacity(.5),
                    fontFamily: 'Default',
                    textTheme: TextTheme(
                      headline1: TextStyle(
                          fontSize: 72.0, fontWeight: FontWeight.bold),
                      headline6: TextStyle(
                          fontSize: 36.0, fontStyle: FontStyle.italic),
                    ),
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: {
                        // for Android - default page transition
                        TargetPlatform.android:
                        CupertinoPageTransitionsBuilder(),

                        // for iOS - one which considers ancestor BackGestureWidthTheme
                        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                      },
                    )),
                home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationUninitialized) {
                      return SplashPage();
                    }
                    if (state is AuthenticationAuthenticated) {
                      return LandingPage(
                        landingPageApiRepository:
                        widget.landingPageApiRepository,
                        externalTenderApiRepository: widget.tenderApiRepository,
                        deliveryApiRepository: widget.deliveryApiRepository,
                      );
                    }
                    if (state is AuthenticationUnauthenticated) {
                      return LoginPage(userRepository: widget.userRepository);
                    }
                    if (state is AuthenticationLoading) {
                      return LoadingIndicator();
                    }
                    return SplashPage();
                  },
                ),
                routes: <String, WidgetBuilder>{
                  '/SplashScreen': (BuildContext context) => SplashPage(),
                  '/LoginScreen': (BuildContext context) => LoginPage(
                    userRepository: widget.userRepository,
                  ),
                  '/SignUpScreen': (BuildContext context) => SignUp(
                    userRepository: widget.userRepository,
                  ),
                  '/LandingScreen': (BuildContext context) => LandingPage(
                    landingPageApiRepository:
                    widget.landingPageApiRepository,
                    externalTenderApiRepository: widget.tenderApiRepository,
                    deliveryApiRepository: widget.deliveryApiRepository,
                  ),
                  /*'/TenderExternalScreen': (BuildContext context) =>
                      TenderExternalList(
                        tenderApiRepository: widget.tenderApiRepository,
                      ),
                  '/TenderPartsScreen': (BuildContext context) =>
                      TenderPartsList(
                        tenderApiRepository: widget.tenderApiRepository,
                      ),
                  '/NewTenderExternalScreen': (BuildContext context) =>
                      CreateExternalTenderParts(
                          tenderApiRepository: widget.tenderApiRepository),
                  '/NewTenderPartsScreen': (BuildContext context) =>
                      CreateTenderParts(
                          tenderApiRepository: widget.tenderApiRepository),
                  '/PickUpExternalScreen': (BuildContext context) =>
                      PickUpExternalList(
                          pickUpApiRepository: widget.pickUpApiRepository),
                  '/PickUpPartsScreen': (BuildContext context) =>
                      PickUpPartsList(
                        pickUpApiRepository: widget.pickUpApiRepository,
                      ),
                  '/NewPickUpExternalScreen': (BuildContext context) =>
                      CreateExternalPickUp(
                          pickUpApiRepository: widget.pickUpApiRepository,
                          pickUpExternal: globals.selectedPickUpExternal),
                  '/NewPickUpPartsScreen': (BuildContext context) =>
                      CreatePickUpPart(
                        pickUpApiRepository: widget.pickUpApiRepository,
                        pickUpPart: globals.selectedPickUpPart,
                      ),
                  '/NewArriveScreen': (BuildContext context) => CreateArrive(
                      deliveryApiRepository: widget.deliveryApiRepository),
                  '/NewDepartScreen': (BuildContext context) => CreateDepart(
                      deliveryApiRepository: widget.deliveryApiRepository),*/
                  '/Settings': (BuildContext context) => Settings(
                    settingsPageApiRepository:
                    widget.settingsPageApiRepository,
                  ),
                  '/Location': (BuildContext context) => Location(),
                  '/TabsConfig': (BuildContext context) => TabsConfig(),
                  '/TenderConfig': (BuildContext context) => TenderConfig(),
                  '/PickUpConfig': (BuildContext context) => PickUpConfig(),
                  '/DeliveryConfig': (BuildContext context) => DeliveryConfig(),
                  '/DisplayConfig': (BuildContext context) => TabDisplayConfig(
                      keyName: globals.selectedKey,
                      displayName: globals.selectedName),
                  /*'/Profile': (BuildContext context) => Profile(
                    profileRepository: widget.profileRepository,
                  ),*/
                  '/ForgotPwdScreen': (BuildContext context) => ForgotPwd(
                    userRepository: widget.userRepository,
                  ),
                  '/Signature': (BuildContext context) => Signature(
                      signaturePageRepository: widget.signaturePageRepository),
                  '/Server': (BuildContext context) => Server(),
                  '/TenderPickUpScan': (BuildContext context) =>
                      TenderPickUpScan(),
                  '/ScanOption': (BuildContext context) => ScanOption()
                })));
  }




}
