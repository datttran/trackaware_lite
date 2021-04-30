import 'package:bloc/bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/create_pickup_event.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';
import 'package:trackaware_lite/states/create_pickup_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';

class CreatePickUpBloc extends Bloc<CreatePickUpEvent, CreatePickUpState> {
  final PickUpApiRepository pickUpApiRepository;

  CreatePickUpBloc({@required this.pickUpApiRepository})
      : assert(pickUpApiRepository != null);

  @override
  CreatePickUpState get initialState => CreatePickUpInitial();

  @override
  Stream<CreatePickUpState> mapEventToState(CreatePickUpEvent event) async* {
    if (event is SendButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;

        transactionRequest.id = null;
        var transactionResponse =
        await pickUpApiRepository.sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          PickUpExternal pickUpExternal = event.pickUpExternal;
          pickUpExternal.isSynced = 1;

          if (pickUpExternal.id != null) {
            var updatedPickUpPart =
            DBProvider.db.updatePickUpExternalForSync(event.pickUpExternal);
            await updatedPickUpPart;

            print(updatedPickUpPart);
          } else {
            var insertPickUpExternal =
            DBProvider.db.insertPickUpExternal(event.pickUpExternal);
            await insertPickUpExternal;

            print(insertPickUpExternal);
          }

          yield PickUpExternalSaved(
              message: "PickUpExternal saved successfully");
        } else {
          yield PickUpExternalSaveFailure(error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield PickUpExternalSaveFailure(error: error.toString());
      }
    }

    if (event is SendPartsButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;

        transactionRequest.id = null;
        var transactionResponse =
        await pickUpApiRepository.sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          PickUpPart pickUpPart = event.pickUpPart;
          pickUpPart.isSynced = 1;

          if (pickUpPart.id != null) {
            var updatedPickUpPart =
            DBProvider.db.updatePickUpPartFoSync(event.pickUpPart);
            await updatedPickUpPart;

            print(updatedPickUpPart);
          }

          yield PickUpPartsSaved(message: "PickUpPart saved successfully");
        } else {
          yield PickUpPartsSaveFailure(error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield PickUpPartsSaveFailure(error: error.toString());
      }
    }

    if (event is AddToListPartButtonClick) {
      var insertPickUpPart = DBProvider.db.insertPickUpPart(event.pickUpPart);
      await insertPickUpPart;

      print(insertPickUpPart);

      yield AddToListPartSuccess();
    }

    if (event is AddToListExternalButtonClick) {
      var insertPickUpExternal =
      DBProvider.db.insertPickUpExternal(event.pickUpExternal);
      await insertPickUpExternal;

      print(insertPickUpExternal);

      yield AddToListExternalSuccess();
    }

    if (event is PickUpSiteViewClick) {
      yield PickUpApiCallLoading();

      try {
        final locationResponse = await pickUpApiRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          yield PickUpSiteResponseFetchSuccess(
              locationResponse: locationResponse);
        } else {
          yield PickUpSiteResponseFetchFailure(
              error: Strings.LOCATION_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield PickUpSiteResponseFetchFailure(error: error.toString());
      }
    }

    if (event is DeliverySiteViewClick) {
      yield DeliverySiteApiCallLoading();

      try {
        final locationResponse = await pickUpApiRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          yield DeliverySiteResponseFetchSuccess(
              locationResponse: locationResponse);
        } else {
          yield DeliverySiteResponseFetchFailure(
              error: Strings.LOCATION_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield DeliverySiteResponseFetchFailure(error: error.toString());
      }
    }

    if (event is LocationViewClick) {
      yield LocationApiCallLoading();

      try {
        final locationResponse = await pickUpApiRepository.fetchLocation();

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

    if (event is DestinationViewClick) {
      yield DestinationApiCallLoading();

      try {
        final locationResponse = await pickUpApiRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          yield DestinationResponseFetchSuccess(
              locationResponse: locationResponse);
        } else {
          yield DestinationResponseFetchFailure(
              error: Strings.LOCATION_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield DestinationResponseFetchFailure(error: error.toString());
      }
    }

    if (event is CheckBoxClick) {
      if (event.isChecked) {
        yield CheckBoxChecked();
      } else {
        yield CheckBoxUnChecked();
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

    if (event is PackageDetailsValidation) {
      yield PackageDetailsApiCallLoading();
      try {
        final packageDetailsResponse =
        await pickUpApiRepository.verifyDestination(event.tag);

        print(packageDetailsResponse);

        if (packageDetailsResponse is List) {
          yield PackageDetailsResponseFetchSuccess(
              packageDetailsResponse: packageDetailsResponse);
        } else {
          yield PackageDetailsResponseFetchFailure(
              error: Strings.PACKAGE_DETAILS_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield PackageDetailsResponseFetchFailure(error: error.toString());
      }
    }

    if (event is OrderNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield OrderNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }

    if (event is PartNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield PartNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }

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
      var deviceId = await pickUpApiRepository.fetchDeviceId();

      if (deviceId.isNotEmpty) {
        yield FetchDeviceIdSuccess(deviceId: deviceId);
      }
    }
  }
}
