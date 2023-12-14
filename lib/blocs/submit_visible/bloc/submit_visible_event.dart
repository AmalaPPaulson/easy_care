part of 'submit_visible_bloc.dart';

@immutable
sealed class SubmitVisibleEvent {}

class VisibilityET extends SubmitVisibleEvent{
  final bool visible;
  VisibilityET({
    required this.visible,
  });

}

class ShowET extends SubmitVisibleEvent {
  final bool show;
  ShowET({
    required this.show,
  });
}