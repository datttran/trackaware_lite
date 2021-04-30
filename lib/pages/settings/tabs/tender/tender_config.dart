import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/tender_config_bloc.dart';
import 'package:trackaware_lite/pages/settings/tabs/tender/tender_config_page.dart';

class TenderConfig extends StatefulWidget {
  
  TenderConfig({Key key})
      : 
        super(key: key);
  @override
  _TenderConfigState createState() =>
      new _TenderConfigState();
}

class _TenderConfigState extends State<TenderConfig> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return TenderConfigBloc(
              );
          },
        child : TenderConfigPage());
  }
}
