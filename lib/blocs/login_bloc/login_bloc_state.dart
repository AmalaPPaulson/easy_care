part of 'login_bloc_bloc.dart';

@immutable
sealed class LoginBlocState {}

final class LoginBlocInitial extends LoginBlocState {}
class LoginFailureST extends LoginBlocState {
  final String? errorMsg;

  LoginFailureST({required this.errorMsg});
}
 
class LoginSuccessST extends LoginBlocState{}
class LoginPageLoadingST extends LoginBlocState{}
class LoginPageLoadedST extends LoginBlocState{}
class LoginClearST extends LoginBlocState {}


