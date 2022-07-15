import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class ToggleCase extends LoginState {}

class LoginSuccessState extends LoginState {
  final User userItem;

  LoginSuccessState(this.userItem);
}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}

class LoginFirebaseAuthExceptionState extends LoginState {
  final String error;

  LoginFirebaseAuthExceptionState(this.error);
}

class ChangeVisibilityState extends LoginState {}

class CreateUserLoadingState extends LoginState {}

class CreateUserSuccessState extends LoginState {
  final UserData userData;

  CreateUserSuccessState(this.userData);
}

class CreateUserErrorState extends LoginState {
  final String error;

  CreateUserErrorState(this.error);
}
