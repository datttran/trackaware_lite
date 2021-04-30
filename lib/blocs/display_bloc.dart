import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/display_event.dart';
import 'package:trackaware_lite/states/display_event.dart';

class DisplayConfigBloc extends Bloc<DisplayConfigEvent, DisplayConfigState> {
  @override
  DisplayConfigState get initialState => DisplayConfigInitial();

  @override
  Stream<DisplayConfigState> mapEventToState(DisplayConfigEvent event) async* {
    if(event is SaveDisplayConfigEvent){
      await DBProvider.db.updateDiscplineConfig(event.keyName, event.disciplineConfigValue);
      yield SaveDisplayConfigSuccess();
    }

    if(event is FetchDisplayConfig){
      var disciplineValues = await DBProvider.db.getDisciplineConfig(event.keyName);
      yield FetchDisplayConfigSuccess(disciplineConfigValues: disciplineValues);
    }
  }
}
