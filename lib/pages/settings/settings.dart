import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/settings_bloc.dart';
import 'package:trackaware_lite/pages/settings/settings_page.dart';
import 'package:trackaware_lite/repositories/settings_repository.dart';

class Settings extends StatefulWidget {
  final SettingsPageApiRepository settingsPageApiRepository;

  Settings({Key key, @required this.settingsPageApiRepository})
      : super(key: key);
  @override
  _SettingsState createState() => new _SettingsState(settingsPageApiRepository);
}

class _SettingsState extends State<Settings> {
  final SettingsPageApiRepository settingsPageApiRepository;

  _SettingsState(this.settingsPageApiRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) {
          return SettingsBloc(
              settingsPageApiRepository: settingsPageApiRepository);
        },
        child: SettingsPage());
  }
}
