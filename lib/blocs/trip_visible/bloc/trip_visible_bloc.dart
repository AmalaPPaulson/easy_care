import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'trip_visible_event.dart';
part 'trip_visible_state.dart';

class TripVisibleBloc extends Bloc<TripVisibleEvent, TripVisibleState> {
  TripVisibleBloc() : super(const TripVisibleState()) {

   
    on<ShowET>((event, emit) {
      bool isShow = !(event.show);
      emit(TripVisibleState(isShow: isShow, card: true));
    });

     //here changing the visibilty of card to show and hide
    on<VisibilityET>((event, emit) {
      bool isVisible = !(event.visible);
      emit(TripVisibleState(isVisible: isVisible, card: false));
    });
  }
}
