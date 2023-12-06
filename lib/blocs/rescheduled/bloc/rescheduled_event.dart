part of 'rescheduled_bloc.dart';

@immutable
sealed class RescheduledEvent {}

class GetRescheduledET extends RescheduledEvent {
  final bool isRefreshed;
  GetRescheduledET({required this.isRefreshed});

}
class PagenatedRescheduledEvent extends RescheduledEvent{}