import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/list_pickup_bloc.dart';
import 'package:trackaware_lite/pages/pickup/part/list/pickup_parts_list.dart';
import 'package:trackaware_lite/repositories/pickup_repository.dart';

class PickUpPartsList extends StatefulWidget {
  final PickUpApiRepository pickUpApiRepository;
  PickUpPartsList({Key key, @required this.pickUpApiRepository})
      : super(key: key);
  @override
  _PickUpPartsListState createState() =>
      new _PickUpPartsListState(pickUpApiRepository);
}

class _PickUpPartsListState extends State<PickUpPartsList> {
  PickUpApiRepository pickUpApiRepository;

  _PickUpPartsListState(this.pickUpApiRepository);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return ListPickUpBloc(pickUpApiRepository: pickUpApiRepository);
        },
        child: PickUpPartsPage(pickUpApiRepository: pickUpApiRepository));
  }
}
