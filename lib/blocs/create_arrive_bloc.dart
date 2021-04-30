import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/create_arrive_event.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';
import 'package:trackaware_lite/states/create_arrive_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class CreateArriveBloc extends Bloc<CreateArriveEvent, CreateArriveState> {
  final DeliveryApiRepository deliveryRepository;

  CreateArriveBloc({@required this.deliveryRepository})
      : assert(deliveryRepository != null);

  @override
  CreateArriveState get initialState => CreateArriveInitial();

  @override
  Stream<CreateArriveState> mapEventToState(CreateArriveEvent event) async* {
    if (event is SubmitButtonClick) {
      yield DeliveryLoading();
      try {
        var deliveryRequest = event.deliveryRequest;
        deliveryRequest.id = null;
        var deliveryResponse =
            await deliveryRepository.updateDeliveryStatus(deliveryRequest);

        if (deliveryResponse != null && deliveryResponse.message != "null") {
          var insertArriveItem = DBProvider.db.insertArrive(event.arrive);
          await insertArriveItem;

          print(insertArriveItem);

          yield ArriveItemSaved(message: deliveryResponse.message);
        } else {
          yield ArriveItemFailure(error: Strings.DELIVERY_FAILURE);
        }
      } catch (error) {
        yield ArriveItemFailure(error: error.toString());
      }
    }

    if (event is FetchUserName) {
      // var userNameValue = await landingPageApiRepository.fetchUserName();

      var user = await DBProvider.db.getUser();

      if (user is List && user.isNotEmpty) {
        yield UserNameFetchSuccess(
            userName: user[0].userName, token: user[0].token);
      } else {
        yield UserNameFetchFailure(error: Strings.UNABLE_TO_FETCH_USERS);
      }
    }

    if (event is FetchDeviceId) {
      var deviceId = await deliveryRepository.fetchDeviceId();

      if (deviceId.isNotEmpty) {
        yield FetchDeviceIdSuccess(deviceId: deviceId);
      }
    }

    if (event is LocationViewClick) {
      yield LocationApiCallLoading();

      try {
        final locationResponse = await deliveryRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          dispatch(LocationSuccessResponse(locationResponse));

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
  }
}
