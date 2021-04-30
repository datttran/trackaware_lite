import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/tender_tab_event.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/states/tender_tab_state.dart';
import 'package:trackaware_lite/globals.dart' as globals;
class TenderTabBloc extends Bloc<TenderTabEvent, TenderTabState> {
  @override
  TenderTabState get initialState => TenderTabInitial();

  @override
  Stream<TenderTabState> mapEventToState(TenderTabEvent event) async* {
    if (event is FetchTenderExternalCount) {
      List<TenderExternal> tenderItems =
          await DBProvider.db.getAllTenderExternalResults();
      yield FetchExternalTenderSuccess(count: tenderItems.length);
    }

    if (event is FetchTenderPartsCount) {
      List<TenderParts> tenderItems =
          await DBProvider.db.getAllTenderPartResults();

      yield FetchTenderPartSuccess(count: tenderItems.length);


    }

    if (event is ResetEvent) {
      yield ResetState();
    }

  }
}
