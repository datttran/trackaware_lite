import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/signature_event.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/repositories/signature_page_repository.dart';
import 'package:trackaware_lite/states/signature_state.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/utils/strings.dart';

class SignatureBloc extends Bloc<SignatureEvent, SignaturePageState> {
  final SignaturePageRepository signaturePageRepository;

  SignatureBloc({
    @required this.signaturePageRepository,
  }) : assert(signaturePageRepository != null);
  @override
  SignaturePageState get initialState => SignatureInitial();

  @override
  Stream<SignaturePageState> mapEventToState(SignatureEvent event) async* {
    if (event is FetchPickUpItems) {
      var pickUpResultResponse = await DBProvider.db
          .getPickUpExternalScannedResults(globals.selectedLoc);

      var pickUpPartResponse = await DBProvider.db
          .getAllPickUpPartResultsByLocationAndScan(globals.selectedLoc);

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
          pickUpExternal.isPart = 1;
          pickUpList.add(pickUpExternal);
        });
      }

      if (pickUpList.isNotEmpty) {
        yield FetchPickUpItemsSuccess(pickUpItems: pickUpList);
      } else {
        yield FetchPickUpItemsFailure(
            error: Strings.UNABLE_TO_FETCH_PICKUP_EXTERNAL_LIST);
      }
    }

    if (event is FetchDeviceId) {
      var deviceId = await signaturePageRepository.fetchDeviceId();

      if (deviceId.isNotEmpty) {
        yield FetchDeviceIdSuccess(deviceId: deviceId);
      }
    }

    if (event is FetchUserName) {
      var user = await DBProvider.db.getUser();

      if (user is List && user.isNotEmpty) {
        yield UserNameFetchSuccess(userName: user[0].userName);
      } else {
        yield UserNameFetchFailure(error: Strings.UNABLE_TO_FETCH_USERS);
      }
    }

    if (event is TransactionEvent) {
      yield SignatureLoading();
      try {
        var transactionRequest = event.transactionRequests;

        int id = transactionRequest.id;
        transactionRequest.id = null;
        var transactionResponse =
            await signaturePageRepository.sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          String type = transactionRequest.packages[0].isPart != null &&
                  transactionRequest.packages[0].isPart == 1
              ? Strings.PART
              : Strings.EXTERNAL;
          if (type == Strings.EXTERNAL) {
            var updatePickUpExternal = DBProvider.db.updatePickUpExternal(id);

            await updatePickUpExternal;
          } else {
            var updatePickUpPart = DBProvider.db.updatePickUpPart(id);

            await updatePickUpPart;
          }

          yield TransactionRequestSuccess(message: transactionResponse.message);
        } else {
          yield TransactionRequestFailure(error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield TransactionRequestFailure(error: error.toString());
      }
    }
  }
}
