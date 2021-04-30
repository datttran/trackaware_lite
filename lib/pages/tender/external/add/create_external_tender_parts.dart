import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/create_external_tender_bloc.dart';
import 'package:trackaware_lite/repositories/external_tender_repository.dart';

import 'create_external_tender_parts_form.dart';

class CreateExternalTenderParts extends StatefulWidget {
  final TenderApiRepository tenderApiRepository;

  CreateExternalTenderParts({Key key, @required this.tenderApiRepository})
      : assert(tenderApiRepository != null),
        super(key: key);
  @override
  _CreateExternalTenderPartsState createState() =>
      new _CreateExternalTenderPartsState(tenderApiRepository);
}

class _CreateExternalTenderPartsState extends State<CreateExternalTenderParts> {
  final TenderApiRepository externalTenderApiRepository;

  _CreateExternalTenderPartsState(this.externalTenderApiRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return CreateExternalTenderBloc(
              externalTenderApiRepository: externalTenderApiRepository);
        },
        child: CreateExternalTenderPartsForm());
  }
}
