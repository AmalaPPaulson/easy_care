import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:meta/meta.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBlocBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  UserRepository userRepository = UserRepository();
  LoginBlocBloc() : super(LoginBlocInitial()) {
    on<LoginBtnPressET>((event, emit) async {
      if (event.phoneNo == null && event.phoneNo!.isEmpty) {
        emit(
          LoginFailureST(errorMsg: 'Please enter Phone Number'),
        );
      } else if (event.phoneNo!.length < 10) {
        emit(
          LoginFailureST(errorMsg: 'PhoneNo Should be 10 digits'),
        );
      } else {
        emit(LoginPageLoadingST());
        await Future.delayed(
          const Duration(seconds: 2),
        );
        emit(LoginSuccessST());
      }
      emit(LoginPageLoadedST());
    });

    on<VerifyPinET>((event, emit) async {
      emit(LoginPageLoadingST());
      try {
        Response? response =
            await userRepository.login(event.phoneNo!, event.pin!);
        if (response!.statusCode == 200) {
          log('loginPhone------------------------------${response.data}');
          await userRepository.setIsLogged(true);
          await userRepository.setPhoneNo(event.phoneNo);
          emit(LoginClearST());
          emit(LoginSuccessST());
        } else {
          emit(LoginFailureST(
              errorMsg: 'Unable to log in with provided credentials.'));
        }
      } catch (e) {
        emit(LoginFailureST(errorMsg: e.toString()));
      }
    });
  }
}
