import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/profile_event.dart';
import 'package:trackaware_lite/models/logout_response.dart';
import 'package:trackaware_lite/models/user_details_response.dart';
import 'package:trackaware_lite/repositories/profile_repository.dart';
import 'package:trackaware_lite/states/profile_state.dart';
import 'package:trackaware_lite/utils/strings.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc({@required this.profileRepository});
  @override
  ProfileState get initialState => ProfileInitial();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchUserDetailsResponse) {
      yield ProfileLoading();
      try {
        var userDetailsResponse = await profileRepository.fetchUserDetails(
            event.userName, event.token);

        print(userDetailsResponse);

        if (userDetailsResponse is UserDetailsResponse) {
          yield ProfileSuccess(userDetailsResponse: userDetailsResponse);
        } else {
          yield ProfileFailure(error: userDetailsResponse.toString());
        }
      } catch (error) {
        yield ProfileFailure(error: error.toString());
      }
    }

    if (event is RefreshTokenEvent) {
      final loginResponse = await profileRepository.login(
          username: event.userName, password: event.password);
      yield RefreshTokenSuccess(loginResponse: loginResponse);
    }

    /*if (event is FetchUser) {
      var fetchUsers = await DBProvider.db.getUser();

      if (fetchUsers.isNotEmpty) {
        yield FetchUserSuccess(users: fetchUsers);
      }
    }*/

    if (event is FetchUserProfileImage) {
      yield ProfileLoading();
      try {
        var userProfileImageResponse = await profileRepository
            .fetchUserProfileImage(event.userName, event.token);

        print(userProfileImageResponse);

        if (userProfileImageResponse.contentLength == 0) {
          yield FetchUserProfileImageFailure(
              error: Strings.UNABLE_TO_FETCH_IMAGE);
        } else {
          yield FetchUserProfileImageSuccess(
              response: userProfileImageResponse);
        }
      } catch (error) {
        yield FetchUserProfileImageFailure(error: error.toString());
      }
    }

    if (event is BackClickAction) {
      yield BackClickSuccess();
    }

    if (event is ResetEvent) {
      yield ProfileInitial();
    }

    if (event is LogoutClickAction) {
      yield ProfileLoading();
      try {
        var logoutResponse = await profileRepository.logout(event.userName);

        print(logoutResponse);

        if (logoutResponse is LogoutResponse) {
          var rememberMe = false;
          var user = await DBProvider.db.getUser();

          if (user?.isNotEmpty == true) {
            rememberMe = user[0].rememberMe == 1;
          }

          if (!rememberMe)
            await DBProvider.db.deleteOnLogout();
          else {
            user[0].logout = 1;
            await DBProvider.db.updateUser(user[0]);
          }

          /* Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          new Directory('$tempPath').deleteSync(); */

          yield LogoutSuccess(logoutResponse: logoutResponse);
        } else {
          yield LogoutFailure(error: Strings.UNABLE_TO_LOGOUT);
        }
      } catch (error) {
        print(error);
        yield LogoutFailure(error: error.toString());
      }
    }
  }
}
