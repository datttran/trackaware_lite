import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/events/tender_pickup_scan_event.dart';
import 'package:trackaware_lite/states/tender_pickup_scan_state.dart';

class TenderPickUpScanBloc
    extends Bloc<TenderPickUpScanEvent, TenderPickUpScanState> {
  @override
  TenderPickUpScanState get initialState => TenderPickUpScanInitial();

  @override
  Stream<TenderPickUpScanState> mapEventToState(
      TenderPickUpScanEvent event) async* {
    if (event is TenderProductionPartsEvent) {
      yield NavigateToTenderProductionPartsScan();
    }

    if (event is TenderExternalPackagesEvent) {
      yield NavigateToTenderExternalPackagesScan();
    }

    if (event is PickUpProductionPartsEvent) {
      yield NavigateToPickUpProductionPartsScan();
    }

    if (event is PickUpExternalPackagesEvent) {
      yield NavigateToPickUpExternalPackagesScan();
    }
  }
}
