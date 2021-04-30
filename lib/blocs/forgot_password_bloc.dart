import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/events/forgot_password_event.dart';
import 'package:trackaware_lite/repositories/user_repository.dart';
import 'package:trackaware_lite/states/forgot_password_state.dart';
import 'package:trackaware_lite/utils/strings.dart';

class ForgotPasswordBloc extends Bloc<ForgotPwdEvent, ForgotPwdState> {
  final UserRespository userRespository;
  ForgotPasswordBloc({@required this.userRespository});
  @override
  ForgotPwdState get initialState => ForgotPwdInitial();

  @override
  Stream<ForgotPwdState> mapEventToState(ForgotPwdEvent event) async* {
    if (event is SendButtonClick) {
      yield ForgotPwdLoading();
      try {
        var forgotPwdResponse = await userRespository.forgotPwd(email: event.email);

        print(forgotPwdResponse);

        if (forgotPwdResponse is String && forgotPwdResponse.contains("Please check your email for temporary password.")) {
          yield ForgotPwdSuccess(message: forgotPwdResponse);
        } else {
          yield ForgotPwdFailure(error: Strings.UNABLE_SEND_EMAIL);
        }
      } catch (error) {
        yield ForgotPwdFailure(error: error.toString());
      }
    }
  }
}
