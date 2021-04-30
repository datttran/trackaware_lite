import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/list_arrive.event.dart';
import 'package:trackaware_lite/states/list_arrive_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class ListArriveBloc
    extends Bloc<ListArriveEvent, ListArriveState> {
  @override
  ListArriveState get initialState => ListArriveInitial();

  @override
  Stream<ListArriveState> mapEventToState(
      ListArriveEvent event) async* {
    if (event is ListArriveItemsEvent) {
      var arriveItems =
          await DBProvider.db.getAllArriveResults();

      if (arriveItems is List) {
        yield ArriveListFetchSuccess(
            arriveList: arriveItems);
      } else {
        yield ArriveListFetchFailure(
            error: Strings.UNABLE_TO_FETCH_ARRIVE_LIST);
      }
    }
  }
}
