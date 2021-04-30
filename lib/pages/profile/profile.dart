import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/profile_bloc.dart';
import 'package:trackaware_lite/pages/profile/profile_page.dart';
import 'package:trackaware_lite/repositories/profile_repository.dart';

class Profile extends StatefulWidget {

  final ProfileRepository profileRepository;
  
  Profile({Key key, @required this.profileRepository})
      : assert(profileRepository != null),
        super(key: key);
  
  @override
  _ProfileState createState() =>
      new _ProfileState(profileRepository : profileRepository);
}

class _ProfileState extends State<Profile> {
  final ProfileRepository profileRepository;

  _ProfileState({@required this.profileRepository});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          builder: (context){
            return ProfileBloc(profileRepository: profileRepository
              );
          },
        child : ProfilePage());
  }
}



