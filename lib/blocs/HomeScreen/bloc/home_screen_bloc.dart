import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(const HomeScreenState()) {
    int currentTab ;
    
    on<TabClickET>((event, emit) {
       log('in the bloc: ${event.tabNo}');
       currentTab = event.tabNo;
       
       emit(HomeScreenState(currentTab: currentTab));

    });
  }
}
