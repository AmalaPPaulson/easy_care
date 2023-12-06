import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'start_service_event.dart';
part 'start_service_state.dart';

class StartServiceBloc extends Bloc<StartServiceEvent, StartServiceState> {
  StartServiceBloc() : super(const StartServiceState()) {
    
     //here changing the visibilty of card to show and hide
    on<VisibilityET>((event, emit) {
      
        bool isVisible = !(event.visible);
        emit(StartServiceState(isVisible:isVisible,card: false));
      
    });
    on<ShowET>((event, emit) {
      bool isShow = !(event.show);
      emit(StartServiceState(isShow: isShow,card: true));

    });
  }
}
