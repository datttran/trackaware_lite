import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/events/sign_up_event.dart';
import 'package:trackaware_lite/repositories/user_repository.dart';
import 'package:trackaware_lite/states/sign_up_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRespository userRespository;

  SignUpBloc({@required this.userRespository})
      : assert(userRespository != null);

  @override
  SignUpState get initialState => SignUpInitial();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SaveBtnClick) {
      yield SignUpLoading();
      try {
        final signUpResponse =
            await userRespository.createUser(map: event.map, file: event.file);

        print(signUpResponse);

        if (signUpResponse.isNotEmpty)
          yield SignUpSuccess(message: signUpResponse);
        else {
          yield SignUpFailure(error: Strings.UNABLE_TO_SIGN_UP);
        }
      } catch (error) {
        yield SignUpFailure(error: error.toString());
      }
    }

    if (event is ImageButtonClick) {
      try {
        var pickedFile = await event.imagePicker.getImage(
            source: event.imageSource,
            maxWidth: null,
            maxHeight: null,
            imageQuality: null);
        if (pickedFile != null) {
          yield ImageButtonClickSuccess(pickedFile: pickedFile);
        }
      } catch (error) {
        print(error);
      }
    }

    if (event is ResetEvent) {
      yield ResetState();
    }
  }
}
