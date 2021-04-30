import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CheckBoxEvent extends Equatable{
  CheckBoxEvent([List props = const []]) : super(props);
}

class CheckBoxClick extends CheckBoxEvent{

  final bool isChecked;

  CheckBoxClick({
      @required this.isChecked,
    }) : super ([isChecked]);
  @override
  String toString()=> 'CheckBoxClick';
}