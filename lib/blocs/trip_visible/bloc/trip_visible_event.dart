part of 'trip_visible_bloc.dart';

@immutable
sealed class TripVisibleEvent {}



class ShowET extends TripVisibleEvent {
  final bool show;
  ShowET({
    required this.show,
  });
}

class VisibilityET extends TripVisibleEvent{
  final bool visible;
  VisibilityET({
    required this.visible,
  });

}
class CleanTripVisibleET extends TripVisibleEvent{
}