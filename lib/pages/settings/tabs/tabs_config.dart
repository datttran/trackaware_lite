import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/tabs_config_bloc.dart';
import 'package:trackaware_lite/pages/settings/tabs/tabs_config_page.dart';

class TabsConfig extends StatefulWidget {
  
  TabsConfig({Key key})
      : 
        super(key: key);
  @override
  _TabsConfigState createState() =>
      new _TabsConfigState();
}

class _TabsConfigState extends State<TabsConfig> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return TabsConfigBloc(
              );
          },
        child : TabsConfigPage());
  }
}
