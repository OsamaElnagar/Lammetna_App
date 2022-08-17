abstract class RegisterStates {}

class RegisterInitState extends RegisterStates {}

class ChangePasswordVisibilityState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}


class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterCreateUserLoadingState extends RegisterStates {}

class RegisterCreateUserSuccessState extends RegisterStates {}

class RegisterCreateUserErrorState extends RegisterStates {
  final String error;

  RegisterCreateUserErrorState(this.error);
}
