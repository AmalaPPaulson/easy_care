// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'trip_visible_bloc.dart';

@immutable
class TripVisibleState {
  final bool isShow;
  final bool isVisible;
  final bool card;
  const TripVisibleState({
     this.isShow =true,
    this.isVisible= true,
     this.card = false,
  });

  TripVisibleState copyWith({
    bool? isShow,
    bool? isVisible,
    bool? card,
  }) {
    return TripVisibleState(
      isShow: isShow ?? this.isShow,
      isVisible: isVisible ?? this.isVisible,
      card: card ?? this.card,
    );
  }
 }


