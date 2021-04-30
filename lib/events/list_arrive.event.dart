import 'package:equatable/equatable.dart';

abstract class ListArriveEvent extends Equatable{
  ListArriveEvent([List props = const []]) : super(props);
}


class ListArriveItemsEvent extends ListArriveEvent{
  
}
