import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/list_depart_event.dart';
import 'package:trackaware_lite/states/list_depart_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class ListDepartBloc
    extends Bloc<ListDepartEvent, ListDepartState> {
  @override
  ListDepartState get initialState => ListDepartInitial();

  @override
  Stream<ListDepartState> mapEventToState(
      ListDepartEvent event) async* {
    if (event is ListDepartItemsEvent) {
      var departItems =
          await DBProvider.db.getAllDepartResults();

      if (departItems is List) {
        yield DepartListFetchSuccess(
            departList: departItems);
      } else {
        yield DepartListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_ARRIVE_LIST);
      }
    }
  }
}
