part of 'start_service_bloc.dart';

@immutable
class StartServiceState {
  final bool isShow;
  final bool isVisible;
  final bool card;
  const StartServiceState({
     this.isShow =true,
     this.isVisible =true,
     this.card = false,
  });


  StartServiceState copyWith({
    bool? isShow,
    bool? isVisible,
    bool? card,
  }) {
    return StartServiceState(
      isShow: isShow ?? this.isShow,
      isVisible: isVisible ?? this.isVisible,
      card: card??this.card,
    );
  }
 }


