import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/list_external_tender_bloc.dart';
import 'package:trackaware_lite/pages/tender/parts/list/tender_parts_list.dart';
import 'package:trackaware_lite/repositories/external_tender_repository.dart';

class TenderPartsList extends StatefulWidget {
  final TenderApiRepository tenderApiRepository;

  TenderPartsList({Key key, @required this.tenderApiRepository})
      : assert(tenderApiRepository != null),
        super(key: key);

  @override
  _TenderPartsListState createState() =>
      new _TenderPartsListState(tenderApiRepository);
}

class _TenderPartsListState extends State<TenderPartsList> {
  final TenderApiRepository externalTenderApiRepository;

  _TenderPartsListState(this.externalTenderApiRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return ListExternalTenderBloc(
              externalTenderApiRepository: externalTenderApiRepository);
        },
        child: TenderPartsPage());
  }
}
