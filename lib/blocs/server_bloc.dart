import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/server_event.dart';
import 'package:trackaware_lite/states/server_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  @override
  ServerState get initialState => ServerInitial();

  @override
  Stream<ServerState> mapEventToState(ServerEvent event) async* {
    if (event is SaveEvent) {
      await DBProvider.db.insertServerConfig(event.serverConfigResponse);

      var serverConfigValues = await DBProvider.db.getServerConfigValues();

      if (serverConfigValues is List) {
        yield FetchServerConfigValuesSuccess(
            serverConfigResponse: serverConfigValues);
      } else {
        yield FetchServerConfigValuesFailure(
            error: Strings.UNABLE_TO_FETCH_SERVER_CONFIG_VALUES);
      }

      yield ServerDetailsSaveSuccess(serverConfigResponse: serverConfigValues);
    }

    if (event is FetchServerConfigValues) {
      var serverConfigValues = await DBProvider.db.getServerConfigValues();

      if (serverConfigValues is List) {
        yield FetchServerConfigValuesSuccess(
            serverConfigResponse: serverConfigValues);
      } else {
        yield FetchServerConfigValuesFailure(
            error: Strings.UNABLE_TO_FETCH_SERVER_CONFIG_VALUES);
      }
    }
  }
}
