import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/server_db.dart';

abstract class ServerState extends Equatable {
  ServerState([List props = const []]) : super(props);
}

class ServerInitial extends ServerState {
  @override
  String toString() {
    return "ServerInitial";
  }
}

class ServerDetailsSaveSuccess extends ServerState {
  final List<ServerConfigResponse> serverConfigResponse;
  ServerDetailsSaveSuccess({@required this.serverConfigResponse});
  @override
  String toString() {
    return "ServerDetailsSaveSuccess $serverConfigResponse";
  }
}

class ServerDetailsSaveFailure extends ServerState {
  final String error;
  ServerDetailsSaveFailure({@required this.error});
  @override
  String toString() {
    return super.toString();
  }
}

class FetchServerConfigValuesSuccess extends ServerState {
  final List<ServerConfigResponse> serverConfigResponse;
  FetchServerConfigValuesSuccess({@required this.serverConfigResponse});
  @override
  String toString() {
    return "FetchServerConfigValuesSuccess";
  }
}

class FetchServerConfigValuesFailure extends ServerState {
  final String error;
  FetchServerConfigValuesFailure({@required this.error});
  @override
  String toString() {
    return "FetchServerConfigValuesSuccess";
  }
}
