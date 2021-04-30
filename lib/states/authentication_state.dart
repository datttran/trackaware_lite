import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable{}

class AuthenticationUninitialized extends AuthenticationState{
  @override
  String toString() {
    return 'AuthenticationUninitialized';
  }
}

class AuthenticationLoading extends AuthenticationState{
  @override
  String toString(){
      return 'AuthenticationLoading';
  }
}

class AuthenticationUnauthenticated extends AuthenticationState{
  @override
  String toString(){
      return 'AuthenticationUnauthenticated';
  }  
}

class AuthenticationAuthenticated extends AuthenticationState{
  @override
  String toString(){
    return 'AuthenticationAuthenticated';
  }
}