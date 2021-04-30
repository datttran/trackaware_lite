import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/blocs/authentication_bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/authentication_event.dart';
import 'package:trackaware_lite/events/login_event.dart';
import 'package:trackaware_lite/models/location_db.dart';
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/models/user_db.dart';
import 'package:trackaware_lite/repositories/user_repository.dart';
import 'package:trackaware_lite/states/login_state.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/globals.dart' as globals;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRespository userRespository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRespository,
    @required this.authenticationBloc,
  })  : assert(userRespository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is FetchLoggedInUser) {
      yield LoginLoading();
      var user = await DBProvider.db.getUser();

      if (user?.isNotEmpty == true) {
        yield FetchUserSuccess(user: user[0]);
      } else {
        yield FetchUserFailure();
      }
    }

    if (event is LoginButtonPressed) {
      yield LoginLoading();

      var list = await DBProvider.db.getServerConfigValues();
      if (list.isNotEmpty) {
        var serverConfig = list[list.length - 1];
        globals.baseUrl = serverConfig.baseUrl;
        globals.serverUserName = serverConfig.userName;
        globals.serverPassword = serverConfig.password;
      }

      try {
        final loginResponse = await userRespository.authenticate(
            username: event.userName, password: event.password);

        print(loginResponse);

        if (loginResponse.accessToken != "null") {
          var userList = await DBProvider.db.getUser();
          var count = 0;
          if (userList.isNotEmpty) {
            for (User user in userList) {
              if (user.token == loginResponse.accessToken) {
                count++;
                user.rememberMe = event.rememberMe ? 1 : 0;
                user.logout = 0;
                DBProvider.db.updateUserRememberMe(user);
              }
            }
            if (count == 0) {
              await DBProvider.db.deleteUsers();
              var user = new User();
              user.userName = event.userName;
              user.token = loginResponse.accessToken;
              user.password = event.password;
              user.rememberMe = event.rememberMe ? 1 : 0;
              user.logout = 0;
              var insertUser = DBProvider.db.insertUser(user);
              await insertUser;
            }
          } else {
            var user = new User();
            user.userName = event.userName;
            user.token = loginResponse.accessToken;
            user.password = event.password;
            user.rememberMe = event.rememberMe ? 1 : 0;
            user.logout = 0;
            var insertUser = DBProvider.db.insertUser(user);
            await insertUser;
          }

          //insert default location values
          var location = Location();
          location.gpsPollInterval = 200;
          location.gpsPostInterval = 200;
          location.gpsUrl = globals.baseUrl + "/geolocation/";
          var insertLocation = DBProvider.db.insertLocation(location);
          await insertLocation;

          //insert default mode values
          var settingsResponse = SettingsResponse();
          settingsResponse.driverMode = 0;
          settingsResponse.useToolNumber = 0;
          settingsResponse.userName = event.userName;
          var insertSettings = DBProvider.db.insertSettings(settingsResponse);
          await insertSettings;

          //insert default displine config values
          List<DisciplineConfigResponse> disciplineConfigValues =
              fetchDisciplineConfigValues();

          if (disciplineConfigValues.isNotEmpty) {
            for (final DisciplineConfigResponse disciplineConfigResponseItem
                in disciplineConfigValues) {
              await DBProvider.db
                  .insertDisciplineConfig(disciplineConfigResponseItem);
            }
          }

          authenticationBloc.dispatch(LoggedIn(loginResponse.accessToken));

          yield LoginSuccess(loginResponse: loginResponse);
        } else {
          yield LoginFailure(error: Strings.loginValidation);
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }

    if (event is CheckBoxClick) {
      if (event.isChecked) {
        yield CheckBoxChecked();
      } else {
        yield CheckBoxUnChecked();
      }
    }
  }

  List<DisciplineConfigResponse> fetchDisciplineConfigValues() {
    var tenderProductionPartDisConfig = DisciplineConfigResponse();
    tenderProductionPartDisConfig.keyName = Strings.TENDER_PRODUCTION_PARTS_KEY;
    tenderProductionPartDisConfig.displayName = Strings.TENDER_PRODUCTION_PARTS;
    tenderProductionPartDisConfig.isVisible = 1;

    var tenderExternalPackagesDisConfig = DisciplineConfigResponse();
    tenderExternalPackagesDisConfig.keyName =
        Strings.TENDER_EXTERNAL_PACKAGES_KEY;
    tenderExternalPackagesDisConfig.displayName =
        Strings.TENDER_EXTERNAL_PACKAGES;
    tenderExternalPackagesDisConfig.isVisible = 1;

    var pickUpExternalPackagesDisConfig = DisciplineConfigResponse();
    pickUpExternalPackagesDisConfig.keyName =
        Strings.PICKUP_EXTERNAL_PACKAGES_KEY;
    pickUpExternalPackagesDisConfig.displayName =
        Strings.PICKUP_EXTERNAL_PACKAGES;
    pickUpExternalPackagesDisConfig.isVisible = 1;

    var pickUpProductionPartDisConfig = DisciplineConfigResponse();
    pickUpProductionPartDisConfig.keyName = Strings.PICKUP_PRODUCTION_PARTS_KEY;
    pickUpProductionPartDisConfig.displayName = Strings.PICKUP_PRODUCTION_PARTS;
    pickUpProductionPartDisConfig.isVisible = 1;

    var departConfig = DisciplineConfigResponse();
    departConfig.keyName = Strings.DEPART_KEY;
    departConfig.displayName = Strings.departTitle;
    departConfig.isVisible = 1;

    var arriveConfig = DisciplineConfigResponse();
    arriveConfig.keyName = Strings.ARRIVE_KEY;
    arriveConfig.displayName = Strings.arriveTitle;
    arriveConfig.isVisible = 1;

    return [
      tenderProductionPartDisConfig,
      tenderExternalPackagesDisConfig,
      pickUpExternalPackagesDisConfig,
      pickUpProductionPartDisConfig,
      departConfig,
      arriveConfig
    ];
  }
}
