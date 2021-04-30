import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/server_bloc.dart';
import 'package:trackaware_lite/pages/settings/server/server_page.dart';

class Server extends StatefulWidget {
  Server({Key key}) : super(key: key);
  @override
  _ServerState createState() => new _ServerState();
}

class _ServerState extends State<Server> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return ServerBloc();
        },
        child: ServerPage());
  }
}
