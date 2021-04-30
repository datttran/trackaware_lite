import 'package:equatable/equatable.dart';
import 'package:trackaware_lite/models/server_db.dart';

abstract class ServerEvent extends Equatable {
  ServerEvent([List props = const []]) : super(props);
}

class SaveEvent extends ServerEvent {
  final ServerConfigResponse serverConfigResponse;
  SaveEvent({this.serverConfigResponse});
  @override
  String toString() {
    return "SaveEvent";
  }
}

class FetchServerConfigValues extends ServerEvent {
  @override
  String toString() {
    return "FetchServerConfigValues";
  }
}
