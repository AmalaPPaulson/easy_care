part of 'login_bloc_bloc.dart';

@immutable
abstract class LoginBlocEvent {}

class LoginBtnPressET extends LoginBlocEvent {
  final String? phoneNo;
  
  LoginBtnPressET({
    required this.phoneNo,
  });
}

class VerifyPinET extends LoginBlocEvent {
  final String? phoneNo;
  final String? pin;
  VerifyPinET({
    required this.phoneNo,
    required this.pin,
  });
}
