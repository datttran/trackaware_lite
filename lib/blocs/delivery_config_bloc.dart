import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/events/delivery_config_event.dart';
import 'package:trackaware_lite/states/delivery_config_state.dart';

class DeliveryConfigBloc
    extends Bloc<DeliveryConfigEvent, DeliveryConfigState> {
  @override
  DeliveryConfigState get initialState => DeliveryConfigInitial();

  @override
  Stream<DeliveryConfigState> mapEventToState(
      DeliveryConfigEvent event) async* {
    if (event is DepartClickAction) {
      yield NavigateToDepartConfig();
    }
    if (event is ArriveClickAction) {
      yield NavigateToArriveConfig();
    }
    if (event is ResetDeliveryConfigEvent) {
      yield ResetDeliveryConfig();
    }
  }
}
