import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/list_pickup_bloc.dart';
import 'package:trackaware_lite/pages/pickup/external/list/pickup_external_list.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';

class PickUpExternalList extends StatefulWidget {
  final PickUpApiRepository pickUpApiRepository;
  PickUpExternalList({Key key, @required this.pickUpApiRepository})
      : super(key: key);
  @override
  _PickUpExternalListState createState() =>
      new _PickUpExternalListState(pickUpApiRepository);
}

class _PickUpExternalListState extends State<PickUpExternalList> {
  PickUpApiRepository pickUpApiRepository;

  _PickUpExternalListState(this.pickUpApiRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return ListPickUpBloc(pickUpApiRepository: pickUpApiRepository);
        },
        child: PickUpExternalPage(
          pickUpApiRepository: pickUpApiRepository,
        ));
  }
}
