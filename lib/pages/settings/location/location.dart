import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/location_bloc.dart';

import 'location_page.dart';

class Location extends StatefulWidget {
  
  Location({Key key})
      : 
        super(key: key);
  @override
  _LocationState createState() =>
      new _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return LocationBloc();
          },
        child : LocationPage());
  }
}



