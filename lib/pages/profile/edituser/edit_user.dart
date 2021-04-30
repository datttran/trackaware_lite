import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/profile_bloc.dart';
import 'package:trackaware_lite/pages/profile/edituser/edit_user_page.dart';
import 'package:trackaware_lite/repositories/profile_repository.dart';

class EditUser extends StatefulWidget {

  final ProfileRepository profileRepository;
  
  EditUser({Key key, @required this.profileRepository})
      : assert(profileRepository != null),
        super(key: key);
  
  @override
  _EditUserState createState() =>
      new _EditUserState(profileRepository : profileRepository);
}

class _EditUserState extends State<EditUser> {
  final ProfileRepository profileRepository;

  _EditUserState({@required this.profileRepository});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return ProfileBloc(profileRepository: profileRepository
              );
          },
        child : EditUserPage());
  }
}



