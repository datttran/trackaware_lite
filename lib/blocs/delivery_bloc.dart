import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/delivery_event.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';
import 'package:trackaware_lite/states/delivery_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryApiRepository deliveryApiRepository;

  DeliveryBloc({@required this.deliveryApiRepository})
      : assert(deliveryApiRepository != null);
  @override
  DeliveryState get initialState => DeliveryInitial();

  @override
  Stream<DeliveryState> mapEventToState(DeliveryEvent event) async* {
    if (event is ResetEvent) {
      yield ResetState();
    }
    if (event is FetchLocation) {
      yield LocationApiCallLoading();

      try {
        final locationResponse = await deliveryApiRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          yield LocationResponseFetchSuccess(
              locationResponse: locationResponse);
        } else {
          yield LocationResponseFetchFailure(
              error: Strings.LOCATION_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield LocationResponseFetchFailure(error: error.toString());
      }
    }

    if (event is CloseMsgEvent) {
      yield ShowHideMsgBlock(showMsg: !event.showMsg);
    }

    if (event is FetchDestinationList) {
      yield Loading();
      var pickUpResultResponse =
          await DBProvider.db.getPickUpExternalResults(event.location);

      var pickUpPartResponse =
          await DBProvider.db.getAllPickUpPartResultsByLocation(event.location);

      var pickUpList = List<PickUpExternal>();

      if (pickUpResultResponse is List) {
        pickUpList.addAll(pickUpResultResponse);
      }

      if (pickUpPartResponse is List && pickUpPartResponse.isNotEmpty) {
        pickUpPartResponse.forEach((element) {
          var pickUpExternal = PickUpExternal();
          pickUpExternal.pickUpSite = element.location;
          pickUpExternal.deliverySite = element.destination;
          pickUpExternal.id = element.id;
          pickUpExternal.scanTime = element.scanTime;
          pickUpExternal.trackingNumber =
              element.orderNumber + ":" + element.partNumber;
          pickUpExternal.isScanned = element.isScanned;
          pickUpExternal.isPart = 1;
          pickUpList.add(pickUpExternal);
        });
      }

      if (pickUpList.isNotEmpty) {
        yield DestinationListFetchSuccess(pickUpResponse: pickUpList);
      } else {
        yield DestinationListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_PICKUP_EXTERNAL_LIST);
      }
    }

    if (event is NextButtonClick) {
      yield NextButtonClickSuccess();
    }
  }
}
