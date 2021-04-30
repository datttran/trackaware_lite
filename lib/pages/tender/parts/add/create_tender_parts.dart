import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/create_external_tender_bloc.dart';
import 'package:trackaware_lite/repositories/external_tender_repository.dart';

import 'create_tender_parts_form.dart';



class CreateTenderParts extends StatefulWidget {

  final TenderApiRepository tenderApiRepository;

  final String orderNo="";
  
  CreateTenderParts({Key key, @required this.tenderApiRepository})
      : assert(tenderApiRepository != null),
        super(key: key);
  @override
  _CreateTenderPartsState createState() =>
      new _CreateTenderPartsState(tenderApiRepository);
}



class _CreateTenderPartsState extends State<CreateTenderParts> {

  final TenderApiRepository tenderApiRepository;

  _CreateTenderPartsState(this.tenderApiRepository);

  @override
  Widget build(BuildContext context) {
    var barCode = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
          builder: (context){
            return CreateExternalTenderBloc(
              externalTenderApiRepository: tenderApiRepository
            );
          },
        child : CreateTenderPartsForm(barCode));
  }
}



