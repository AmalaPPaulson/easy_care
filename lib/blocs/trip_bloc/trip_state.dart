part of 'trip_bloc.dart';

@immutable
class TripState {
  final Position? startPosition;
  final Position? finalPosition;
  final String? status;
  final bool isLoading;
  final String? errorMsg;
 
  final DateTime? startTime;
  final DateTime? endTime;
  final bool started;
  final bool reached ;
  
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
     
     
      });

  TripState copyWith({
    Position? startPosition,
    Position? finalPosition,
    String? status,
    bool? isLoading,
    String? errorMsg,
  
    DateTime? startTime,
    DateTime? endTime,
    bool? reached,
    
    bool? started,
  }) {
    return TripState(
      startPosition: startPosition ?? this.startPosition,
      finalPosition: finalPosition ?? this.finalPosition,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMsg: errorMsg ?? this.errorMsg,
    
      startTime: startTime   ?? this.startTime,
      endTime:endTime??this.endTime,
      reached: reached??this.reached,
    
      started: started??this.started,
    );
  }
}
