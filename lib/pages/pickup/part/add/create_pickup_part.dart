import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/create_pickup_bloc.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/pages/pickup/part/add/create_pickup_part_form.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';

class CreatePickUpPart extends StatefulWidget {
  final PickUpApiRepository pickUpApiRepository;
  final PickUpPart pickUpPart;

  final String orderNo = "";

  CreatePickUpPart(
      {Key key, @required this.pickUpApiRepository, @required this.pickUpPart})
      : assert(pickUpApiRepository != null),
        super(key: key);
  @override
  _CreatePickUpPartState createState() =>
      new _CreatePickUpPartState(pickUpApiRepository, pickUpPart);
}

class _CreatePickUpPartState extends State<CreatePickUpPart> {
  final PickUpApiRepository pickUpApiRepository;
  final PickUpPart pickUpPart;

  _CreatePickUpPartState(this.pickUpApiRepository, this.pickUpPart);

  @override
  Widget build(BuildContext context) {
    var barCode = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
        builder: (context) {
          return CreatePickUpBloc(pickUpApiRepository: pickUpApiRepository);
        },
        child: CreatePickUpPartForm(barCode, pickUpPart));
  }
}
