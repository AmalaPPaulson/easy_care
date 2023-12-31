// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitial extends AuthBlocState {}

class AuthStartedST extends AuthBlocState {}

class AuthSuccessST extends AuthBlocState {}

class AuthFailureST extends AuthBlocState {}

class AuthTripDetailST extends AuthBlocState {
  final String? tripStatus;
  AuthTripDetailST({
    this.tripStatus,
  });
}

class ClearST extends AuthBlocState {}

class AuthLogoutFailST extends AuthBlocState {
  final String? errorMsg;
  AuthLogoutFailST({required this.errorMsg});
}

class AuthLogoutSuccST extends AuthBlocState {}
