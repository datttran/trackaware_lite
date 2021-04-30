import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/list_depart_bloc.dart';
import 'package:trackaware_lite/pages/delivery/depart/list/depart_list.dart';

@Deprecated("Not being used anymore. Functionality moved to DepartTab")
class DepartList extends StatefulWidget {
  
  DepartList({Key key})
      
        :super(key: key);
  @override
  _DepartListState createState() =>
      new _DepartListState();
}


class _DepartListState extends State<DepartList> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return ListDepartBloc();
          },
        child : DepartPage());
  }
}