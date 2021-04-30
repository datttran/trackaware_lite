import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/events/pickup_config_event.dart';
import 'package:trackaware_lite/states/pickup_config_state.dart';

class PickUpConfigBloc extends Bloc<PickUpConfigEvent, PickUpConfigState> {
  @override
  PickUpConfigState get initialState => PickUpConfigInitial();

  @override
  Stream<PickUpConfigState> mapEventToState(PickUpConfigEvent event) async* {
    if (event is PickUpProductionPartsClickAction) {
      yield NavigateToPickUpProductionPartsConfig();
    }
    if (event is PickUpExternalPackagesClickAction) {
      yield NavigateToPickUpExternalPackagesConfig();
    }
    if (event is ResetPickUpConfigEvent) {
      yield ResetPickUpConfig();
    }
  }
}
