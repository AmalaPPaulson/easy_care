part of 'voice_record_bloc.dart';

@immutable
class VoiceRecordState {
 final RecordingState ? recordingState;
  const VoiceRecordState({
    this.recordingState,
  });



  VoiceRecordState copyWith({
    RecordingState ? recordingState,
  }) {
    return VoiceRecordState(
      recordingState: recordingState ?? this.recordingState,
    );
  }
}



