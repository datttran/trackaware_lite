import 'package:bloc/bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/create_depart_event.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';
import 'package:trackaware_lite/states/create_depart_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';

class CreateDepartBloc extends Bloc<CreateDepartEvent, CreateDepartState> {
  final DeliveryApiRepository deliveryRepository;

  CreateDepartBloc({@required this.deliveryRepository})
      : assert(deliveryRepository != null);

  @override
  CreateDepartState get initialState => CreateDepartInitial();

  @override
  Stream<CreateDepartState> mapEventToState(CreateDepartEvent event) async* {
    if (event is TrackingNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield TrackingNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
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

    if (event is DeliveryCompleteButtonClick) {
      yield DeliveryLoading();
      try {
        var deliveryRequest = event.deliveryRequest;
        deliveryRequest.id = null;
        var deliveryResponse =
            await deliveryRepository.updateDeliveryStatus(deliveryRequest);

        if (deliveryResponse != null && deliveryResponse.message != "null") {
          var insertDepartItem = DBProvider.db.insertDepart(event.depart);
          await insertDepartItem;

          print(insertDepartItem);

          yield DepartItemSaved(message: deliveryResponse.message);
        } else {
          yield DepartItemFailure(error: Strings.DELIVERY_FAILURE);
        }
      } catch (error) {
        yield DepartItemFailure(error: error.toString());
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
