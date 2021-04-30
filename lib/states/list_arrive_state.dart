import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/arrive_db.dart';

abstract class ListArriveState extends Equatable{
  ListArriveState([List props = const []]) : super(props);
}

class ListArriveInitial extends ListArriveState{
  ListArriveInitial([List props = const []]) : super(props);
}

class LoadArriveList extends ListArriveState{
  @override
  String toString() => 'LoadArriveList';
}

class ArriveListFetchSuccess extends ListArriveState{
  final List<Arrive> arriveList;

  ArriveListFetchSuccess({@required this.arriveList}) : super([arriveList]);
  @override
  String toString() => 'ArriveListFetchSuccess { ArriveList: $arriveList}';
}

class ArriveListFetchFailure extends ListArriveState{
  final String error;

  ArriveListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'ArriveListFetchFailure { error: $error}';
}