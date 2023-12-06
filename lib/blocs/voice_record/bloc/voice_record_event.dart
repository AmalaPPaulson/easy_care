part of 'voice_record_bloc.dart';

@immutable
sealed class VoiceRecordEvent {}

class StartRecordingET extends VoiceRecordEvent{}

class PlayRecordingET extends VoiceRecordEvent{}

class RecordDeleteET extends VoiceRecordEvent{}
 
class ClickPicET extends VoiceRecordEvent{}
