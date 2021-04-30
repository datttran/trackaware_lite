import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:trackaware_lite/models/delivery_request.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/transaction_request.dart';

abstract class LandingPageEvent extends Equatable {
  LandingPageEvent([List props = const []]) : super(props);
}

class LoadSyncDataEvent extends LandingPageEvent {}

class SyncButtonClick extends LandingPageEvent {
  final TransactionRequest transactionRequests;
  final int transactionRequestCount;

  SyncButtonClick(
      {@required this.transactionRequests,
      @required this.transactionRequestCount})
      : super([transactionRequests, transactionRequestCount]);

  @override
  String toString() {
    return 'SyncButtonClick : TrasactionRequests: $transactionRequests, Count : $transactionRequestCount';
  }
}

class SyncDeliveryItems extends LandingPageEvent {
  final DeliveryRequest deliveryRequest;
  final int deliveryRequestCount;

  SyncDeliveryItems(
      {@required this.deliveryRequest, @required this.deliveryRequestCount})
      : super([deliveryRequest, deliveryRequestCount]);

  @override
  String toString() {
    return 'SyncDeliveryItems : DeliveryRequest: $deliveryRequest, Count : $deliveryRequestCount';
  }
}

class ScanButtonClick extends LandingPageEvent {
  @override
  String toString() {
    return 'ScanButtonClick';
  }
}

class SettingsClick extends LandingPageEvent {
  @override
  String toString() {
    return 'SettingsClick';
  }
}

class CheckLocationPermission extends LandingPageEvent {
  final Location location;
  CheckLocationPermission({@required this.location}) : super([location]);
  @override
  String toString() {
    return "CheckLocationPermission : $location";
  }
}

class CheckLocationService extends LandingPageEvent {
  final Location location;
  CheckLocationService({@required this.location}) : super([location]);
  @override
  String toString() {
    return "CheckLocationService : $location";
  }
}

class ChangeLocationFetchInterval extends LandingPageEvent {
  final int interval;
  final Location location;
  ChangeLocationFetchInterval(
      {@required this.interval, @required this.location})
      : super([interval, location]);
  @override
  String toString() {
    return "ChangeLocatiionFetchInterval: $interval";
  }
}

class ListenToLocation extends LandingPageEvent {
  final Location location;
  ListenToLocation({@required this.location}) : super([location]);
  @override
  String toString() {
    return "Location : $location";
  }
}

class StopListeningToLocation extends LandingPageEvent {
  final Location location;
  StopListeningToLocation({@required this.location}) : super([location]);
  @override
  String toString() {
    return "Location : $location";
  }
}

class FetchLocationValues extends LandingPageEvent {
  @override
  String toString() {
    return "FetchLocationValues";
  }
}

class PeriodicLocationUpdate extends LandingPageEvent {
  final String locationRequest;
  PeriodicLocationUpdate(this.locationRequest) : super([locationRequest]);
  @override
  String toString() {
    return "PeriodicLocationUpdate";
  }
}

class FetchUserName extends LandingPageEvent {
  @override
  String toString() {
    return "FetchUserName";
  }
}

class FetchDeviceId extends LandingPageEvent {
  @override
  String toString() {
    return "FetchDeviceId";
  }
}

class FetchSettings extends LandingPageEvent {
  final String userName;
  FetchSettings({@required this.userName}) : super([userName]);
  @override
  String toString() {
    return "FetchSettings";
  }
}

class ProfileImageClickAction extends LandingPageEvent {
  @override
  String toString() {
    return "ProfileImageClickAction";
  }
}

class PriorityFetch extends LandingPageEvent {
  @override
  String toString() {
    return "PriorityFetch";
  }
}

class LocationFetch extends LandingPageEvent {
  @override
  String toString() {
    return "LocationFetch";
  }
}

class UpdatePickUpItem extends LandingPageEvent {
  final pickUpExternal;
  UpdatePickUpItem({@required this.pickUpExternal});
  @override
  String toString() {
    return "UpdatePickUpItem : $pickUpExternal";
  }
}

class FetchUserProfileImage extends LandingPageEvent {
  final String userName;
  final String token;
  FetchUserProfileImage({@required this.userName, @required this.token})
      : super([userName, token]);
  @override
  String toString() {
    return "FetchUserProfileImage - User ; $userName, Token - $token";
  }
}

class ResetEvent extends LandingPageEvent {
  @override
  String toString() {
    return "ResetEvent";
  }
}

class ScanImageEvent extends LandingPageEvent {
  final bool displayScanImage;
  ScanImageEvent({@required this.displayScanImage});
  @override
  String toString() {
    return super.toString();
  }
}
