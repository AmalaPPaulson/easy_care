import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'submit_visible_event.dart';
part 'submit_visible_state.dart';

class SubmitVisibleBloc extends Bloc<SubmitVisibleEvent, SubmitVisibleState> {
  SubmitVisibleBloc() : super(const SubmitVisibleState()) {
    //here changing the visibilty of card to show and hide
    on<VisibilityET>((event, emit) {
      bool isVisible = !(event.visible);
      emit(SubmitVisibleState(isVisible: isVisible, card: false));
    });
    on<ShowET>((event, emit) {
      bool isShow = !(event.show);
      emit(SubmitVisibleState(isShow: isShow, card: true));
    });
    on<CleanSubmitVisibleET>((event, emit) {
      
      emit(state.copyWith(isShow: true, card: false,isVisible: true));
    });
  }

}
