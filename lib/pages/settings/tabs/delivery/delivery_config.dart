import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/delivery_config_bloc.dart';
import 'package:trackaware_lite/pages/settings/tabs/delivery/delivery_config_page.dart';


class DeliveryConfig extends StatefulWidget {
  
  DeliveryConfig({Key key})
      : 
        super(key: key);
  @override
  _DeliveryConfigState createState() =>
      new _DeliveryConfigState();
}

class _DeliveryConfigState extends State<DeliveryConfig> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return DeliveryConfigBloc(
              );
          },
        child : DeliveryConfigPage());
  }
}
