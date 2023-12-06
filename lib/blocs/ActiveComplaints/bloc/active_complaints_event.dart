part of 'active_complaints_bloc.dart';

@immutable
sealed class ActiveComplaintsEvent {}

class GetAcitveComplaintsET extends ActiveComplaintsEvent {
  final bool isRefreshed;
  GetAcitveComplaintsET({required this.isRefreshed});

}
class PagenatedActiveEvent extends ActiveComplaintsEvent{}