import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/authentication_event.dart';
import 'package:trackaware_lite/models/server_db.dart';
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/repositories/user_repository.dart';
import 'package:trackaware_lite/states/authentication_state.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/utils/strings.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRespository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(UserRespository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      // final bool hasToken = await userRepository.hasToken();

      var user = await DBProvider.db.getUser();

      if (user.isNotEmpty) {
        var settings = await DBProvider.db.getSettings(user[0].userName);

        if (settings.isNotEmpty) {
          globals.isDriverMode = settings[settings.length - 1].driverMode == 1;
          globals.useToolNumber =
              settings[settings.length - 1].useToolNumber == 1;
          globals.isPickUpOnTender =
              settings[settings.length - 1].pickUpOnTender == 1;
        }
      }

      var disciplineConfigValues =
          await DBProvider.db.fetchAllDisciplineConfig();

      if (disciplineConfigValues.isNotEmpty) {
        for (final DisciplineConfigResponse disciplineConfigValuesResponseItem
            in disciplineConfigValues) {
          switch (disciplineConfigValuesResponseItem.keyName) {
            case Strings.TENDER_PRODUCTION_PARTS_KEY:
              {
                globals.tenderProductionPartsDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.TENDER_EXTERNAL_PACKAGES_KEY:
              {
                globals.tenderExternalPackagesDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.PICKUP_PRODUCTION_PARTS_KEY:
              {
                globals.pickUpProductionPartsDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.PICKUP_EXTERNAL_PACKAGES_KEY:
              {
                globals.pickUpExternalPackagesDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.DEPART_KEY:
              {
                globals.departDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.ARRIVE_KEY:
              {
                globals.arriveDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
          }
        }
      }

      if (user is List && user.isNotEmpty) {
        var serverConfigList = await fetchServerConfig();
        if (serverConfigList.isNotEmpty) {
          var serverConfig = serverConfigList[serverConfigList.length - 1];
          globals.baseUrl = serverConfig.baseUrl;
          globals.serverUserName = serverConfig.userName;
          globals.serverPassword = serverConfig.password;
        }
        if (user[0].token.isNotEmpty &&
            (user[0].logout == 0 || user[0].logout == null))
          yield AuthenticationAuthenticated();
        else {
          if (serverConfigList.isEmpty) await insertServerConfig();
          yield AuthenticationUnauthenticated();
        }
      } else {
        var serverConfigList = await fetchServerConfig();
        if (serverConfigList.isEmpty) await insertServerConfig();
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      // await userRepository.persistUser(event.userName);
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }

  Future<void> insertServerConfig() async {
    var serverConfigResponse = ServerConfigResponse();
    serverConfigResponse.baseUrl = globals.baseUrl;
    serverConfigResponse.userName = globals.serverUserName;
    serverConfigResponse.password = globals.serverPassword;
    await DBProvider.db.insertServerConfig(serverConfigResponse);
  }

  Future<List<ServerConfigResponse>> fetchServerConfig() async {
    return await DBProvider.db.getServerConfigValues();
  }
}
