import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/location_event.dart';
import 'package:trackaware_lite/states/location_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  @override
  LocationState get initialState => LocationInitial();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {

    if(event is SaveButtonClick){
      var insertLocationItem =
          DBProvider.db.insertLocation(event.location);
      await insertLocationItem;

      print(insertLocationItem);

      yield LocationSaveSuccess();
    }

    if(event is FetchLocationValues){
      var locationResponse = await DBProvider.db.getLocation();

      if (locationResponse is List) {
        yield FetchLocationSuccess(locationList: locationResponse);
      } else {
        yield FetchLocationFailure(
            error: Strings.UNABLE_TO_FETCH_LOCATION_LIST);
      }
    }
    
  }
}