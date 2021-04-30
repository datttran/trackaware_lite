import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/models/depart_db.dart';

abstract class ListDepartState extends Equatable{
  ListDepartState([List props = const []]) : super(props);
}

class ListDepartInitial extends ListDepartState{
  ListDepartInitial([List props = const []]) : super(props);
}

class LoadDepartList extends ListDepartState{
  @override
  String toString() => 'LoadArriveList';
}

class DepartListFetchSuccess extends ListDepartState{
  final List<Depart> departList;

  DepartListFetchSuccess({@required this.departList}) : super([departList]);
  @override
  String toString() => 'DepartListFetchSuccess { DepartList: $departList}';
}

class DepartListFetchFailure extends ListDepartState{
  final String error;

  DepartListFetchFailure({@required this.error}) : super([error]);
  @override
  String toString() => 'DepartListFetchFailure { error: $error}';
}