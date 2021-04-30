import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/display_bloc.dart';
import 'package:trackaware_lite/pages/settings/tabs/display/display_page.dart';

class TabDisplayConfig extends StatefulWidget {
  final String keyName;
  final String displayName;
  TabDisplayConfig({Key key,@required this.keyName, @required this.displayName})
      : 
        super(key: key);
  @override
  _TabDisplayConfigState createState() =>
      new _TabDisplayConfigState(keyName:keyName,displayName:displayName);
}

class _TabDisplayConfigState extends State<TabDisplayConfig> {
  final String keyName;
  final String displayName;
  _TabDisplayConfigState({@required this.keyName,@required this.displayName});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return DisplayConfigBloc(
              );
          },
        child : DisplayPage(keyName: keyName,displayName : displayName));
  }
}
