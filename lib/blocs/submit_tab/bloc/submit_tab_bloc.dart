import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'submit_tab_event.dart';
part 'submit_tab_state.dart';

class SubmitTabBloc extends Bloc<SubmitTabEvent, SubmitTabState> {
  SubmitTabBloc() : super(const SubmitTabState()) {
     int currentTab ;
     on<TabClickET>((event, emit) {
       log('in the bloc: ${event.tabNo}');
       currentTab = event.tabNo; 
       emit(SubmitTabState(currentTab: currentTab));

    });
  }
}
