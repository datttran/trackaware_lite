import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/signature_bloc.dart';
import 'package:trackaware_lite/pages/delivery/tab/signature/signature_page.dart';
import 'package:trackaware_lite/repositories/signature_page_repository.dart';

class Signature extends StatefulWidget {
  final SignaturePageRepository signaturePageRepository;
  Signature({Key key, @required this.signaturePageRepository})
      : assert(signaturePageRepository != null),
        super(key: key);
  @override
  _SignatureState createState() =>
      new _SignatureState(signaturePageRepository: signaturePageRepository);
}

class _SignatureState extends State<Signature> {
  final SignaturePageRepository signaturePageRepository;
  _SignatureState({@required this.signaturePageRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return SignatureBloc(
              signaturePageRepository: signaturePageRepository);
        },
        child: SignaturePage());
  }
}
