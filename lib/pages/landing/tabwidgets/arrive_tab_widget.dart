import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/list_arrive_bloc.dart';
import 'package:trackaware_lite/pages/delivery/arrive/list/arrive_list.dart';

class ArriveTabWidget extends StatefulWidget {
  ArriveTabWidget({Key key})
      
        :super(key: key);
  @override
  _ArriveListState createState() =>
      new _ArriveListState();
}

class _ArriveListState extends State<ArriveTabWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return ListArriveBloc();
          },
        child : ArrivePage());
  }
}
