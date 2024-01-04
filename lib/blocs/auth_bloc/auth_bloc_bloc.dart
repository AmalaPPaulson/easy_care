import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
      // checking internet connectivity
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        try {
          Response? response = await userRepository.logout();
          if (response!.statusCode == 200) {
            await userRepository.setIsLogged(false);
            await userRepository.setIsStartTrip(false);
            emit(AuthLogoutSuccST());
          } else {
            emit(AuthLogoutFailST(errorMsg: 'Unable to log out'));
          }
        } catch (e) {
          emit(AuthLogoutFailST(errorMsg: e.toString()));
        }
      } else {
        log('internet connection is not there');
        Fluttertoast.showToast(
            msg: ' No internet, please check your connection');
      }
    });
  }
}
