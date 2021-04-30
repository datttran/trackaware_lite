import 'package:bloc/bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/create_external_tender_event.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/repositories/external_tender_repository.dart';
import 'package:trackaware_lite/states/create_external_tender_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/utils/transactions.dart';

class CreateExternalTenderBloc
    extends Bloc<CreateExternalTenderEvent, CreateExternalTenderState> {
  final TenderApiRepository externalTenderApiRepository;

  CreateExternalTenderBloc({@required this.externalTenderApiRepository})
      : assert(externalTenderApiRepository != null);

  @override
  CreateExternalTenderState get initialState => CreateExternalTenderInitial();

  @override
  Stream<CreateExternalTenderState> mapEventToState(
      CreateExternalTenderEvent event) async* {
    if (event is SendButtonClick) {
      var insertTenderExternal =
          DBProvider.db.insertTenderExternal(event.tenderExternal);
      await insertTenderExternal;

      print(insertTenderExternal);

      yield TenderExternalSaved(message: "");
    }

    if (event is FetchPriorityResponse) {
      yield PriorityApiCallLoading();

      try {
        final priorityResponse =
            await externalTenderApiRepository.fetchPriority();

        print(priorityResponse);

        if (priorityResponse is List) {
          yield InitPriorityResponseFetchSuccess(
              priorityResponse: priorityResponse);
        } else {
          yield InitPriorityResponseFetchFailure(
              error: Strings.PRIORITY_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield InitPriorityResponseFetchFailure(error: error.toString());
      }
    }

    if (event is SendPartsButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;

        transactionRequest.id = null;
        var transactionResponse = await externalTenderApiRepository
            .sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          TenderParts tenderPart = event.tenderParts;
          tenderPart.isSynced = 1;

          if (tenderPart.id != null) {
            var updateTenderPart =
                DBProvider.db.updateTenderPart(tenderPart.id);
            await updateTenderPart;
          } else {
            var insertTenderPart = DBProvider.db.insertTenderPart(tenderPart);
            await insertTenderPart;
          }

          if (globals.isPickUpOnTender) {
            PickUpPart pickUpPart = PickUpPart();
            pickUpPart.location = tenderPart.location;
            pickUpPart.destination = tenderPart.destination;
            pickUpPart.orderNumber = tenderPart.orderNumber;
            pickUpPart.partNumber = tenderPart.partNumber;
            pickUpPart.scanTime =
                (DateTime.now().millisecondsSinceEpoch / 1000).round();
            pickUpPart.isSynced = 1;
            pickUpPart.isScanned = 0;
            pickUpPart.isDelivered = 0;
            pickUpPart.keepScannedValues = tenderPart.keepScannedValues;

            var transactionRequest = generateTransactionFromPickupPart(
                pickUpPart, event.deviceIdValue, event.userName);

            transactionRequest.id = null;
            var transactionResponse = await externalTenderApiRepository
                .sendTransaction(transactionRequest);

            if (transactionResponse != null &&
                transactionResponse.message != "null") {
              var insertPickUpPart = DBProvider.db.insertPickUpPart(pickUpPart);
              await insertPickUpPart;

              print(insertPickUpPart);
            }
          } else {
            PickUpPart pickUpPart = PickUpPart();
            pickUpPart.location = tenderPart.location;
            pickUpPart.destination = tenderPart.destination;
            pickUpPart.orderNumber = tenderPart.orderNumber;
            pickUpPart.partNumber = tenderPart.partNumber;
            pickUpPart.scanTime =
                (DateTime.now().millisecondsSinceEpoch / 1000).round();
            pickUpPart.isSynced = 0;
            pickUpPart.isScanned = 0;
            pickUpPart.isDelivered = 0;
            pickUpPart.keepScannedValues = tenderPart.keepScannedValues;
            var insertPickUpPart = DBProvider.db.insertPickUpPart(pickUpPart);
            await insertPickUpPart;
          }

          yield TenderPartsSaved(message: transactionResponse.message);
        } else {
          yield TenderPartsFailure(error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield TenderPartsFailure(error: error.toString());
      }
    }

    if (event is AddToListPartButtonClick) {
      TenderParts tenderPart = event.tenderParts;
      tenderPart.isSynced = 0;

      var insertTenderPart = DBProvider.db.insertTenderPart(tenderPart);
      await insertTenderPart;
      yield AddToListPartSuccess();
    }

    if (event is SendExternalButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;

        transactionRequest.id = null;
        var transactionResponse = await externalTenderApiRepository
            .sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          TenderExternal tenderExternal = event.tenderExternal;
          tenderExternal.isSynced = 1;

          if (tenderExternal.id != null) {
            var updateTenderExternal =
                DBProvider.db.updateTenderExternal(tenderExternal.id);
            await updateTenderExternal;
          } else {
            var insertTenderExternal =
                DBProvider.db.insertTenderExternal(tenderExternal);
            await insertTenderExternal;
          }

          if (globals.isPickUpOnTender) {
            PickUpExternal pickUpExternal = PickUpExternal();
            pickUpExternal.pickUpSite = tenderExternal.location;
            pickUpExternal.deliverySite = tenderExternal.destination;
            pickUpExternal.trackingNumber = tenderExternal.trackingNumber;
            pickUpExternal.scanTime =
                (DateTime.now().millisecondsSinceEpoch / 1000).round();
            pickUpExternal.isSynced = 1;
            pickUpExternal.isScanned = 0;
            pickUpExternal.isDelivered = 0;
            pickUpExternal.isPart = 0;

            var transactionRequest = generateTransactionFromPickupExternal(
                pickUpExternal, event.deviceIdValue, event.userName);

            transactionRequest.id = null;
            var transactionResponse = await externalTenderApiRepository
                .sendTransaction(transactionRequest);

            if (transactionResponse != null &&
                transactionResponse.message != "null") {
              var insertPickUpExternal =
                  DBProvider.db.insertPickUpExternal(pickUpExternal);
              await insertPickUpExternal;

              print(insertPickUpExternal);
            }
          } else {
            PickUpExternal pickUpExternal = PickUpExternal();
            pickUpExternal.pickUpSite = tenderExternal.location;
            pickUpExternal.deliverySite = tenderExternal.destination;
            pickUpExternal.trackingNumber = tenderExternal.trackingNumber;
            pickUpExternal.scanTime =
                (DateTime.now().millisecondsSinceEpoch / 1000).round();
            pickUpExternal.isSynced = 0;
            pickUpExternal.isScanned = 0;
            pickUpExternal.isDelivered = 0;
            pickUpExternal.isPart = 0;

            var insertPickUpExternal =
                DBProvider.db.insertPickUpExternal(pickUpExternal);
            await insertPickUpExternal;
          }

          yield TenderExternalSaved(message: transactionResponse.message);
        } else {
          yield TenderExternalFailure(error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield TenderExternalFailure(error: error.toString());
      }
    }

    if (event is AddToListExternalButtonClick) {
      TenderExternal tenderExternal = event.tenderExternal;
      tenderExternal.isSynced = 0;

      var insertTenderExternal =
          DBProvider.db.insertTenderExternal(tenderExternal);
      await insertTenderExternal;
      yield AddToListExternalSuccess();
    }

    if (event is PriorityViewClick) {
      yield PriorityApiCallLoading();

      try {
        final priorityResponse =
            await externalTenderApiRepository.fetchPriority();

        print(priorityResponse);

        if (priorityResponse is List) {
          dispatch(PriortySuccessResponse(priorityResponse));

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

    if (event is LocationViewClick) {
      yield LocationApiCallLoading();

      try {
        final locationResponse =
            await externalTenderApiRepository.fetchLocation();

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

    if (event is DestinationViewClick) {
      yield DestinationApiCallLoading();

      try {
        final locationResponse =
            await externalTenderApiRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          dispatch(DestinationSuccessResponse(locationResponse));

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

    if (event is ToolNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield ToolNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }

    if (event is RefNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield RefNumberScanSuccess(barCode: barcodeScanRes);
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
      var deviceId = await externalTenderApiRepository.fetchDeviceId();

      if (deviceId.isNotEmpty) {
        yield FetchDeviceIdSuccess(deviceId: deviceId);
      }
    }
  }
}
