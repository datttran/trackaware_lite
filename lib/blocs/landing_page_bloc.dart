import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:location/location.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/landing_page_event.dart';
import 'package:trackaware_lite/repositories/landing_page_repository.dart';
import 'package:trackaware_lite/states/landing_page_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  final LandingPageApiRepository landingPageApiRepository;

  LandingPageBloc({
    @required this.landingPageApiRepository,
  }) : assert(landingPageApiRepository != null);
  @override
  LandingPageState get initialState => LandingPageInitial();

  @override
  Stream<LandingPageState> mapEventToState(LandingPageEvent event) async* {
    if (event is SyncButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequests;

        String status = transactionRequest.status;
        int id = transactionRequest.id;
        transactionRequest.id = null;
        var transactionResponse =
            await landingPageApiRepository.sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          if (status == Strings.TENDER) {
            String type = transactionRequest.packages[0].containerNum.isEmpty
                ? Strings.PART
                : Strings.EXTERNAL;
            if (type == Strings.EXTERNAL) {
              var updateTenderExternal = DBProvider.db.updateTenderExternal(id);

              await updateTenderExternal;
            } else {
              var updateTenderPart = DBProvider.db.updateTenderPart(id);

              await updateTenderPart;
            }
          } else {
            String type = transactionRequest.packages[0].labelNum.isEmpty
                ? Strings.PART
                : Strings.EXTERNAL;
            if (type == Strings.EXTERNAL) {
              var updatePickUpExternal = DBProvider.db.updatePickUpExternal(id);

              await updatePickUpExternal;
            } else {
              var updatePickUpPart = DBProvider.db.updatePickUpPart(id);

              await updatePickUpPart;
            }
          }

          yield TenderTransactionRequestSuccess(
              message: transactionResponse.message);
        } else {
          yield TenderTransactionRequestFailure(
              error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield TenderTransactionRequestFailure(error: error.toString());
      }
    }

    if (event is FetchUserProfileImage) {
      try {
        var userProfileImageResponse = await landingPageApiRepository
            .fetchUserProfileImage(event.userName, event.token);

        print(userProfileImageResponse);

        if (userProfileImageResponse.contentLength == 0) {
          yield FetchUserProfileImageFailure(
              error: Strings.UNABLE_TO_FETCH_IMAGE);
        } else {
          yield FetchUserProfileImageSuccess(
              response: userProfileImageResponse);
        }
      } catch (error) {
        yield FetchUserProfileImageFailure(error: error.toString());
      }
    }

    if (event is SyncDeliveryItems) {
      yield DeliveryLoading();
      try {
        var deliveryRequest = event.deliveryRequest;

        int id = deliveryRequest.id;
        String status = deliveryRequest.status;
        deliveryRequest.id = null;
        var deliveryResponse = await landingPageApiRepository
            .updateDeliveryStatus(deliveryRequest);

        if (deliveryResponse != null && deliveryResponse.message != "null") {
          if (status == Strings.ARRIVE_LOWERCASE) {
            var updateArriveItem = DBProvider.db.updateArrive(id);

            await updateArriveItem;
          } else {
            var updateDepartItem = DBProvider.db.updateDepart(id);

            await updateDepartItem;
          }

          yield DeliveryRequestSuccess(message: deliveryResponse.message);
        } else {
          yield DeliveryRequestFailure(error: Strings.DELIVERY_FAILURE);
        }
      } catch (error) {
        yield DeliveryRequestFailure(error: error.toString());
      }
    }

    if (event is LoadSyncDataEvent) {
      yield SyncLoading();
      /* var tenderExternalResultResponse =
          await DBProvider.db.getAllTenderExternalResults();

      if (tenderExternalResultResponse is List) {
        yield ExternalTenderListFetchSuccess(
            tenderExternalResponse: tenderExternalResultResponse);
      } else {
        yield ExternalTenderListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_TENDER_EXTERNAL_LIST);
      }

      var tenderPartsResultResponse =
          await DBProvider.db.getAllTenderPartResults();

      if (tenderPartsResultResponse is List) {
        yield TenderPartsListFetchSuccess(
            tenderPartsResponse: tenderPartsResultResponse);
      } else {
        yield TenderPartsListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_TENDER_PARTS_LIST);
      }

      var pickupPartsResultResponse =
          await DBProvider.db.getAllPickUpPartResults();

      if (pickupPartsResultResponse is List) {
        yield PickUpPartsListFetchSuccess(
            pickUpPartsResponse: pickupPartsResultResponse);
      } else {
        yield PickUpPartsListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_PICKUP_PARTS_LIST);
      }

      var pickupExternalResultResponse =
          await DBProvider.db.getAllPickUpExternalResults();

      if (pickupExternalResultResponse is List) {
        yield PickUpExternalListFetchSuccess(
            pickUpExternalResponse: pickupExternalResultResponse);
      } else {
        yield PickUpExternalListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_PICKUP_EXTERNAL_LIST);
      } */

      var arriveListResponse = await DBProvider.db.getAllArriveResults();

      if (arriveListResponse is List) {
        yield ArriveListItemsFetchSuccess(arriveResponse: arriveListResponse);
      } else {
        yield ArriveListItemsFetchFailure(
            error: Strings.UNABLE_TO_FETCH_ARRIVE_LIST);
      }

      var departListResponse = await DBProvider.db.getAllDepartResults();

      if (departListResponse is List) {
        yield DepartListItemsFetchSuccess(departResponse: departListResponse);
      } else {
        yield DepartListItemsFetchFailure(
            error: Strings.UNABLE_TO_FETCH_DEPART_LIST);
      }
    }

    if (event is ScanButtonClick) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield ScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanFailure(error: "Scan failed!");
      }
    }

    //location permission
    if (event is CheckLocationPermission) {
      var location = event.location;
      var _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          yield PermissionStatusResult(isPermissionEnabled: false);
          return;
        } else {
          yield PermissionStatusResult(isPermissionEnabled: true);
        }
      } else {
        yield PermissionStatusResult(isPermissionEnabled: true);
      }
    }

    //location service enabled
    if (event is CheckLocationService) {
      var location = event.location;
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      yield LocationServiceStatus(isLocationServiceEnabled: _serviceEnabled);
    }

    if (event is ChangeLocationFetchInterval) {
      var location = event.location;
      //conversion to milliseconds
      var interval = event.interval * 1000;
      var hasSettingsChanged = await location.changeSettings(
          accuracy: LocationAccuracy.high, interval: interval);

      if (hasSettingsChanged) {
        yield LocationSettingsChangeSuccess();
      } else {
        yield LocationSettingsChangeFailure();
      }
    }

    if (event is FetchLocationValues) {
      var locationResponse = await DBProvider.db.getLocation();

      if (locationResponse is List) {
        yield FetchLocationSuccess(locationList: locationResponse);
      } else {
        yield FetchLocationFailure(
            error: Strings.UNABLE_TO_FETCH_LOCATION_LIST);
      }
    }

    if (event is PeriodicLocationUpdate) {
      var locationRequest = event.locationRequest;
      var locationResponse =
          await landingPageApiRepository.updateLocation(locationRequest);

      if (locationResponse.message != null &&
          locationResponse.message.isNotEmpty) {
        yield LocationRequestSuccess(message: locationResponse.message);
      } else {
        yield LocationRequestFailure(error: Strings.LOCATION_UPDATE_FAILURE);
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
      var deviceId = await landingPageApiRepository.fetchDeviceId();

      if (deviceId.isNotEmpty) {
        yield FetchDeviceIdSuccess(deviceId: deviceId);
      }
    }

    if (event is FetchSettings) {
      var settingsList = await DBProvider.db.getSettings(event.userName);

      if (settingsList.isNotEmpty) {
        yield FetchSettingsSuccess(settings: settingsList);
      }
    }

    if (event is ProfileImageClickAction) {
      yield ProfileImageClickActionSuccess();
    }

    if (event is PriorityFetch) {
      try {
        final priorityResponse = await landingPageApiRepository.fetchPriority();

        print(priorityResponse);

        if (priorityResponse is List) {
          await DBProvider.db.deletePriorityResponse();
          priorityResponse.forEach((element) async {
            await DBProvider.db.insertPriorityResponse(element);
          });

          yield PriorityResponseFetchSuccess(
              priorityResponse: priorityResponse);
        } else {
          yield PriorityResponseFetchFailure(
              error: Strings.PRIORITY_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield PriorityResponseFetchFailure(error: error.toString());
      }
    }

    if (event is LocationFetch) {
      try {
        final locationResponse = await landingPageApiRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          await DBProvider.db.deleteLocationResponse();
          locationResponse.forEach((element) async {
            await DBProvider.db.insertLocationResponse(element);
          });

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

    if (event is UpdatePickUpItem) {
      int updatePickUpExternalScanStatus = -1;
      if (event.pickUpExternal.isPart == 1) {
        updatePickUpExternalScanStatus = await DBProvider.db
            .updatePickUpPartScanStatus(
                event.pickUpExternal.id, event.pickUpExternal.isScanned);
      } else {
        updatePickUpExternalScanStatus = await DBProvider.db
            .updatePickUpExternalScanStatus(
                event.pickUpExternal.id, event.pickUpExternal.isScanned);
      }

      if (updatePickUpExternalScanStatus == 1) {
        yield UpdatePickUpItemSuccess();
      } else {
        yield UpdatePickUpItemFailure(error: Strings.UPDATE_FAILED);
      }
    }

    if (event is ResetEvent) {
      yield ResetState();
    }

    if (event is ScanImageEvent) {
      if (event.displayScanImage)
        yield ShowScan();
      else
        yield HideScan();
    }
  }
}
