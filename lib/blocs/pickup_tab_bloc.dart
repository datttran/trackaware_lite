import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/pickup_tab_event.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/states/pickup_tab_state.dart';

class PickUpTabBloc extends Bloc<PickupTabEvent, PickupTabState> {
  @override
  PickupTabState get initialState => PickupTabInitial();

  @override
  Stream<PickupTabState> mapEventToState(PickupTabEvent event) async* {
    if (event is FetchPickUpExternalCount) {
      List<PickUpExternal> pickUpItems =
          await DBProvider.db.getAllPickUpExternalResults();
      yield FetchExternalPickUpSuccess(count: pickUpItems.length);
    }

    if (event is FetchPickUpPartsCount) {
      List<PickUpPart> pickUpItems =
          await DBProvider.db.getAllPickUpPartResults();
      yield FetchPickUpPartSuccess(count: pickUpItems.length);
    }

    if (event is ResetEvent) {
      yield ResetState();
    }
  }
}
