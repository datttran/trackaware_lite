import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/events/tabs_config_event.dart';
import 'package:trackaware_lite/states/tabs_config_state.dart';

class TabsConfigBloc extends Bloc<TabsConfigEvent, TabsConfigState> {
  @override
  TabsConfigState get initialState => TabsConfigInitial();

  @override
  Stream<TabsConfigState> mapEventToState(TabsConfigEvent event) async* {
    if (event is TenderClickAction) {
      yield NavigateToTenderConfig();
    }
    if (event is PickUpClickAction) {
      yield NavigateToPickUpConfig();
    }
    if (event is DeliveryClickAction) {
      yield NavigateToDeliveryConfig();
    }

    if (event is ResetEvent) {
      yield ResetState();
    }
  }
}
