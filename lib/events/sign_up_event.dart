import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class SignUpEvent extends Equatable {
  SignUpEvent([List props = const []]) : super(props);
}

class SaveBtnClick extends SignUpEvent {
  final Map<String, dynamic> map;
  final File file;
  SaveBtnClick({@required this.map, @required this.file});
  @override
  String toString() {
    return super.toString();
  }
}

class ImageButtonClick extends SignUpEvent {
  final ImageSource imageSource;
  final ImagePicker imagePicker;
  ImageButtonClick({@required this.imageSource, @required this.imagePicker});
  @override
  String toString() {
    return "ImageButtonClick";
  }
}

class ResetEvent extends SignUpEvent {
  @override
  String toString() {
    return "ResetEvent";
  }
}
