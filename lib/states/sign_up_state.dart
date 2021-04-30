import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class SignUpState extends Equatable {
  SignUpState([List props = const []]) : super(props);
}

class SignUpInitial extends SignUpState {
  @override
  String toString() {
    return "SignUpIniial";
  }
}

class SignUpSuccess extends SignUpState {
  final String message;
  SignUpSuccess({@required this.message});
  @override
  String toString() {
    return "SignUpSuccess";
  }
}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure({@required this.error});
  @override
  String toString() {
    return "SignUpFailure";
  }
}

class ImageButtonClickSuccess extends SignUpState {
  final PickedFile pickedFile;
  ImageButtonClickSuccess({@required this.pickedFile});
  @override
  String toString() {
    return "ImageButtonClickSuccess";
  }
}

class SignUpLoading extends SignUpState {
  @override
  String toString() {
    return super.toString();
  }
}

class ResetState extends SignUpState {
  @override
  String toString() {
    return "ResetState";
  }
}
