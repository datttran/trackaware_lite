import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/create_arrive_bloc.dart';
import 'package:trackaware_lite/repositories/delivery_repository.dart';

import 'create_arrive_form.dart';

class CreateArrive extends StatefulWidget {

  final DeliveryApiRepository deliveryApiRepository;
  
  CreateArrive({Key key, @required this.deliveryApiRepository})
      : assert(deliveryApiRepository != null),
        super(key: key);
  @override
  _CreateArriveState createState() =>
      new _CreateArriveState(deliveryApiRepository);
}

class _CreateArriveState extends State<CreateArrive> {

  final DeliveryApiRepository deliveryApiRepository;

  _CreateArriveState(this.deliveryApiRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return CreateArriveBloc(
              deliveryRepository: deliveryApiRepository
            );
          },
        child : CreateArriveForm());
  }
}



