part of 'completed_bloc.dart';

@immutable
sealed class CompletedEvent {}

class GetCompletedET extends CompletedEvent {
  final bool isRefreshed;
  GetCompletedET({required this.isRefreshed});

}
class PagenatedCompleteEvent extends CompletedEvent{}

