import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/list_pickup_event.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';
import 'package:trackaware_lite/states/list_pickup_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class ListPickUpBloc extends Bloc<ListPickUpEvent, ListPickUpState> {
  final PickUpApiRepository pickUpApiRepository;

  ListPickUpBloc({@required this.pickUpApiRepository})
      : assert(pickUpApiRepository != null);

  @override
  ListPickUpState get initialState => ListPickUpInitial();

  @override
  Stream<ListPickUpState> mapEventToState(ListPickUpEvent event) async* {
    if (event is SendExternalButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;
        var pickUpExternalId = transactionRequest.id;
        transactionRequest.id = null;
        var transactionResponse =
            await pickUpApiRepository.sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          if (pickUpExternalId != null) {
            var updatedPickUpPart =
                DBProvider.db.updatePickUpExternalSync(pickUpExternalId);
            await updatedPickUpPart;

            print(updatedPickUpPart);
          }

          yield PickUpExternalSaved(
              message: "PickUpExternal saved successfully");
        } else {
          yield PickUpExternalFailure(error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield PickUpExternalFailure(error: error.toString());
      }
    }

    if (event is SendPartsButtonClick) {
      yield TransactionLoading();
      try {
        var transactionRequest = event.transactionRequest;
        var pickUpPartId = transactionRequest.id;
        transactionRequest.id = null;
        var transactionResponse =
            await pickUpApiRepository.sendTransaction(transactionRequest);

        if (transactionResponse != null &&
            transactionResponse.message != "null") {
          if (pickUpPartId != null) {
            var updatedPickUpPart =
                DBProvider.db.updatePickUpPartSync(pickUpPartId);
            await updatedPickUpPart;

            print(updatedPickUpPart);
          }

          yield PickUpPartsSaved(message: "PickUpPart saved successfully");
        } else {
          yield PickUpPartsFailure(error: Strings.TRANSACTION_FAILURE);
        }
      } catch (error) {
        yield PickUpPartsFailure(error: error.toString());
      }
    }

    if (event is ListExternalPickUpItemsEvent) {
      var pickUpExternalResultResponse =
          await DBProvider.db.getAllPickUpExternalResults();

      if (pickUpExternalResultResponse is List) {
        yield ExternalPickUpListFetchSuccess(
            pickUpExternalResponse: pickUpExternalResultResponse);
      } else {
        yield ExternalPickUpListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_TENDER_EXTERNAL_LIST);
      }
    }

    if (event is ListPickUpPartItemsEvent) {
      var pickUpPartsResultResponse =
          await DBProvider.db.getAllPickUpPartResults();

      if (pickUpPartsResultResponse is List) {
        yield PickUpPartsListFetchSuccess(
            pickUpPartsResponse: pickUpPartsResultResponse);
      } else {
        yield PickUpPartsListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_PICKUP_PARTS_LIST);
      }
    }

    if (event is FetchDeviceId) {
      var deviceId = await pickUpApiRepository.fetchDeviceId();

      if (deviceId.isNotEmpty) {
        yield FetchDeviceIdSuccess(deviceId: deviceId);
      }
    }

    if (event is FetchUserName) {
      var user = await DBProvider.db.getUser();

      if (user is List && user.isNotEmpty) {
        yield UserNameFetchSuccess(
            userName: user[0].userName, token: user[0].token);
      } else {
        yield UserNameFetchFailure(error: Strings.UNABLE_TO_FETCH_USERS);
      }
    }
  }
}
