part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class AuthStartedET extends AuthBlocEvent {}

class AuthStartedET2 extends AuthBlocEvent {}

class AuthLoggedInEvent extends AuthBlocEvent {}

class AuthLogoutEvent extends AuthBlocEvent {}

class AuthTripStartedET extends AuthBlocEvent {}
