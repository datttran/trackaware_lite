import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/list_tender_external_event.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/repositories/external_tender_repository.dart';
import 'package:trackaware_lite/states/list_external_tender_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/transactions.dart';
import 'package:trackaware_lite/globals.dart' as globals;

class ListExternalTenderBloc
    extends Bloc<ListExternalTenderEvent, ListExternalTenderState> {
  final TenderApiRepository externalTenderApiRepository;

  ListExternalTenderBloc({@required this.externalTenderApiRepository})
      : assert(externalTenderApiRepository != null);

  @override
  ListExternalTenderState get initialState => ListExternalTenderInitial();

  @override
  Stream<ListExternalTenderState> mapEventToState(
      ListExternalTenderEvent event) async* {
    if (event is ListExternalTenderItemsEvent) {
      var tenderExternalResultResponse =
          await DBProvider.db.getAllTenderExternalResults();

      if (tenderExternalResultResponse is List) {
        yield ExternalTenderListFetchSuccess(
            tenderExternalResponse: tenderExternalResultResponse);
      } else {
        yield ExternalTenderListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_TENDER_EXTERNAL_LIST);
      }
    }

    if (event is SendExternalButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;
        int tenderId = transactionRequest.id;
        transactionRequest.id = null;
        var transactionResponse = await externalTenderApiRepository
            .sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          if (tenderId != null) {
            var updateTenderExternal =
                DBProvider.db.updateTenderExternal(tenderId);
            await updateTenderExternal;
          }

          if (globals.isPickUpOnTender) {
            PickUpExternal pickUpExternal = PickUpExternal();
            pickUpExternal.pickUpSite = event.transactionRequest.location;
            pickUpExternal.deliverySite =
                event.transactionRequest.packages[0].deliveryLocation;
            pickUpExternal.trackingNumber =
                event.transactionRequest.packages[0].labelNum;
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
            pickUpExternal.pickUpSite = transactionRequest.location;
            pickUpExternal.deliverySite =
                transactionRequest.packages[0].deliveryLocation;
            pickUpExternal.trackingNumber =
                transactionRequest.packages[0].labelNum;
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

    if (event is SendPartsButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;
        var tenderPartId = transactionRequest.id;
        transactionRequest.id = null;
        var transactionResponse = await externalTenderApiRepository
            .sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          if (tenderPartId != null) {
            var updateTenderPart = DBProvider.db.updateTenderPart(tenderPartId);
            await updateTenderPart;
          }

          if (globals.isPickUpOnTender) {
            PickUpPart pickUpPart = PickUpPart();
            pickUpPart.location = event.transactionRequest.location;
            pickUpPart.destination =
                event.transactionRequest.packages[0].deliveryLocation;
            pickUpPart.orderNumber =
                event.transactionRequest.packages[0].orderNum;
            pickUpPart.partNumber = event.transactionRequest.packages[0].item;
            pickUpPart.scanTime =
                (DateTime.now().millisecondsSinceEpoch / 1000).round();
            pickUpPart.isSynced = 1;
            pickUpPart.isScanned = 0;
            pickUpPart.isDelivered = 0;

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
            pickUpPart.location = transactionRequest.location;
            pickUpPart.destination =
                transactionRequest.packages[0].deliveryLocation;
            pickUpPart.orderNumber = transactionRequest.packages[0].orderNum;
            pickUpPart.partNumber = transactionRequest.packages[0].item;
            pickUpPart.scanTime =
                (DateTime.now().millisecondsSinceEpoch / 1000).round();
            pickUpPart.isSynced = 0;
            pickUpPart.isScanned = 0;
            pickUpPart.isDelivered = 0;

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

    if (event is FetchDeviceId) {
      var deviceId = await externalTenderApiRepository.fetchDeviceId();

      if (deviceId.isNotEmpty) {
        yield FetchDeviceIdSuccess(deviceId: deviceId);
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

    if (event is ListTenderPartItemsEvent) {
      var tenderPartsResultResponse =
          await DBProvider.db.getAllTenderPartResults();


      if (tenderPartsResultResponse is List) {
        yield TenderPartsListFetchSuccess(
            tenderPartsResponse: tenderPartsResultResponse);
      } else {
        yield TenderPartsListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_TENDER_PARTS_LIST);
      }
    }

    //scan of tender part items
    if (event is ScanTenderPartEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      var count = 0;

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        var tenderPartsResults = await DBProvider.db.getAllTenderPartResults();
        if (tenderPartsResults is List) {
          tenderPartsResults.forEach((element) {
            var trackingNum = element.orderNumber + ":" + element.partNumber;
            if (barcodeScanRes.contains(trackingNum)) {
              count++;
              element.isScanned = 1;
              DBProvider.db.updateTenderPartScanStatus(element);
              createPickUpPart(element);
            }
          });
        }
      }

      if (count > 0) {
        yield ScanSuccess(scanCount: count);
      } else {
        yield ScanFailure();
      }
    }

    //scan of tender external items
    if (event is ScanTenderExternalEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      var count = 0;

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        var tenderExternalResults =
            await DBProvider.db.getAllTenderExternalResults();
        if (tenderExternalResults is List) {
          tenderExternalResults.forEach((element) {
            if (barcodeScanRes.contains(element.trackingNumber)) {
              count++;
              element.isScanned = 1;
              DBProvider.db.updateTenderExternalScanStatus(element);
              createPickUpExternal(element);
            }
          });
        }
      }

      if (count > 0) {
        yield ScanSuccess(scanCount: count);
      } else {
        yield ScanFailure();
      }
    }
  }

  void createPickUpPart(TenderParts element) {
    var pickUpPart = PickUpPart();
    pickUpPart.destination = element.destination;
    pickUpPart.isScanned = 0;
    pickUpPart.isSynced = element.isSynced;
    pickUpPart.keepScannedValues = element.keepScannedValues;
    pickUpPart.location = element.location;
    pickUpPart.orderNumber = element.orderNumber;
    pickUpPart.partNumber = element.partNumber;
    pickUpPart.scanTime = element.scanTime;
    DBProvider.db.insertPickUpPart(pickUpPart);
  }

  void createPickUpExternal(TenderExternal element) {
    var pickUpExternal = PickUpExternal();
    pickUpExternal.deliverySite = element.destination;
    pickUpExternal.isScanned = 0;
    pickUpExternal.isSynced = element.isSynced;
    pickUpExternal.pickUpSite = element.location;
    pickUpExternal.trackingNumber = element.trackingNumber;
    pickUpExternal.scanTime = element.scanTime;
    pickUpExternal.isPart = 0;
    DBProvider.db.insertPickUpExternal(pickUpExternal);
  }
}
