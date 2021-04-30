import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/create_depart_bloc.dart';
import 'package:trackaware_lite/pages/delivery/depart/add/create_depart_form.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';


class CreateDepart extends StatefulWidget {

  final DeliveryApiRepository deliveryApiRepository;
  
  CreateDepart({Key key, @required this.deliveryApiRepository})
      : assert(deliveryApiRepository != null),
        super(key: key);
  @override
  _CreateDepartState createState() =>
      new _CreateDepartState(deliveryApiRepository);
}

class _CreateDepartState extends State<CreateDepart> {

  final DeliveryApiRepository deliveryApiRepository;

  _CreateDepartState(this.deliveryApiRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return CreateDepartBloc(
              deliveryRepository: deliveryApiRepository
            );
          },
        child : CreateDepartForm());
  }
}



