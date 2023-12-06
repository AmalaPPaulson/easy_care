part of 'trip_bloc.dart';

@immutable
class TripState {
  final Position? startPosition;
  final Position? finalPosition;
  final String? status;
  final bool isLoading;
  final String? errorMsg;
  final bool card;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool started;
  final bool reached ;
  final bool isShow;
  final bool isVisible;
  const TripState(
      {this.startPosition,
      this.finalPosition,
      this.status,
      this.isLoading = false,
      this.errorMsg,
      this.started=false,
      this.startTime,
      this.endTime,
      this.reached = false,
      this .isShow = true,
      this.isVisible = true,
       this.card = false,
      });

  TripState copyWith({
    Position? startPosition,
    Position? finalPosition,
    String? status,
    bool? isLoading,
    String? errorMsg,
    bool? card,
    DateTime? startTime,
    DateTime? endTime,
    bool? reached,
    bool? isShow,
    bool? isVisible,
    bool? started,
  }) {
    return TripState(
      startPosition: startPosition ?? this.startPosition,
      finalPosition: finalPosition ?? this.finalPosition,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      card: card??this.card,
      startTime: startTime   ?? this.startTime,
      endTime:endTime??this.endTime,
      reached: reached??this.reached,
      isShow: isShow?? this.isShow,
      isVisible: isVisible??this.isVisible,
      started: started??this.started,
    );
  }
}
