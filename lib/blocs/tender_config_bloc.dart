import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/events/tender_config_event.dart';
import 'package:trackaware_lite/states/tender_config_state.dart';

class TenderConfigBloc extends Bloc<TenderConfigEvent, TenderConfigState> {
  @override
  TenderConfigState get initialState => TenderConfigInitial();

  @override
  Stream<TenderConfigState> mapEventToState(TenderConfigEvent event) async* {
    if (event is TenderProductionPartsClickAction) {
      yield NavigateToTenderProductionPartsConfig();
    }
    if (event is TenderExternalPackagesClickAction) {
      yield NavigateToTenderExternalPackagesConfig();
    }
    if (event is ResetTenderConfigEvent) {
      yield ResetTenderConfig();
    }
  }
}
