import 'package:equatable/equatable.dart';

abstract class CheckBoxState extends Equatable{
  CheckBoxState([List props = const []]) : super(props);
}

class CheckBoxChecked extends CheckBoxState{
  @override
  String toString() =>'CheckBoxChecked';
}

class CheckBoxUnChecked extends CheckBoxState{
  @override
  String toString() =>'CheckBoxUnChecked';
}
