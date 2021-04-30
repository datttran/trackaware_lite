import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/list_external_tender_bloc.dart';
import 'package:trackaware_lite/pages/tender/external/list/tender_external_packages_list.dart';
import 'package:trackaware_lite/repositories/external_tender_repository.dart';

class TenderExternalList extends StatefulWidget {
  final TenderApiRepository tenderApiRepository;

  TenderExternalList({Key key, @required this.tenderApiRepository})
      : assert(tenderApiRepository != null),
        super(key: key);

  @override
  _TenderExternalListState createState() =>
      new _TenderExternalListState(tenderApiRepository);
}

class _TenderExternalListState extends State<TenderExternalList> {
  final TenderApiRepository externalTenderApiRepository;

  _TenderExternalListState(this.externalTenderApiRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return ListExternalTenderBloc(
              externalTenderApiRepository: externalTenderApiRepository);
        },
        child: TenderExternalPage());
  }
}
