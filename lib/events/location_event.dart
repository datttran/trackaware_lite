import 'package:equatable/equatable.dart';
import 'package:trackaware_lite/models/location_db.dart';

abstract class LocationEvent extends Equatable{
  LocationEvent([List props = const []]) : super(props);
}

class SaveButtonClick extends LocationEvent{
  final Location location;
  SaveButtonClick(this.location) : super([location]);
  @override
  String toString() {
    return "SaveButtonClick";
  }
}

class FetchLocationValues extends LocationEvent{
  @override
  String toString() {
    return "FetchLocationValues";
  }
}