import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/pickup_config_bloc.dart';
import 'package:trackaware_lite/pages/settings/tabs/pickup/pickup_config_page.dart';

class PickUpConfig extends StatefulWidget {
  
  PickUpConfig({Key key})
      : 
        super(key: key);
  @override
  _PickUpConfigState createState() =>
      new _PickUpConfigState();
}

class _PickUpConfigState extends State<PickUpConfig> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return PickUpConfigBloc(
              );
          },
        child : PickUpConfigPage());
  }
}
