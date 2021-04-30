import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/create_pickup_bloc.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/pages/pickup/external/add/create_external_pickup_form.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';

class CreateExternalPickUp extends StatefulWidget {
  final PickUpApiRepository pickUpApiRepository;
  final PickUpExternal pickUpExternal;

  final String orderNo = "";

  CreateExternalPickUp(
      {Key key,
      @required this.pickUpApiRepository,
      @required this.pickUpExternal})
      : assert(pickUpApiRepository != null),
        super(key: key);
  @override
  _CreateExternalPickUpState createState() =>
      new _CreateExternalPickUpState(pickUpApiRepository, pickUpExternal);
}

class _CreateExternalPickUpState extends State<CreateExternalPickUp> {
  final PickUpApiRepository pickUpApiRepository;
  final PickUpExternal pickUpExternal;

  _CreateExternalPickUpState(this.pickUpApiRepository, this.pickUpExternal);

  @override
  Widget build(BuildContext context) {
    var barCode = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
        builder: (context) {
          return CreatePickUpBloc(pickUpApiRepository: pickUpApiRepository);
        },
        child: CreateExternalPickUpForm(barCode, pickUpExternal));
  }
}
