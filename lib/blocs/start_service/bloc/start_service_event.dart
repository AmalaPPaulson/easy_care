part of 'start_service_bloc.dart';

@immutable
sealed class StartServiceEvent {}


class VisibilityET extends StartServiceEvent{
  final bool visible;
  VisibilityET({
    required this.visible,
  });

}
class ShowET extends StartServiceEvent {
  final bool show;

  ShowET({
    required this.show,
   
  });
}
class CleanStartServiceET extends StartServiceEvent{}