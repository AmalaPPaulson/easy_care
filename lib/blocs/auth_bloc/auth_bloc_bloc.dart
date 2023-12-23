import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:meta/meta.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  UserRepository userRepository = UserRepository();
  AuthBlocBloc() : super(AuthBlocInitial()) {
    //to show splashscreen for 2 seconds
    on<AuthStartedET>((event, emit) {
      emit(AuthStartedST());
      Future.delayed(const Duration(seconds: 2), () async {
        add(AuthStartedET2());
      });
    });

    on<AuthStartedET2>((event, emit) async {
      emit(AuthStartedST());
      await Future.delayed(const Duration(seconds: 2), () async {
        //add(AuthStartedET2());
      });
      bool? isLogged = userRepository.getIsLogged();
      bool? isStartTrip = userRepository.getIsStartTrip();
      String? tripStatus = userRepository.getTripStatus();
      emit(ClearST());
      if (isLogged) {
        if (isStartTrip) {
          emit(AuthTripDetailST(tripStatus: tripStatus));
        } else {
          emit(AuthSuccessST());
        }
      } else {
        emit(AuthFailureST());
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      try {
        Response? response = await userRepository.logout();
        if (response!.statusCode == 200) {
          await userRepository.setIsLogged(false);
          await userRepository.setIsStartTrip(false);
          emit(AuthLogoutSuccST());
        } else {
          emit(AuthLogoutFailST(
              errorMsg: 'Unable to log in with provided credentials.'));
        }
      } catch (e) {
        emit(AuthLogoutFailST(errorMsg: e.toString()));
      }
    });
  }
}
