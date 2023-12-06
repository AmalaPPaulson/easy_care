

import 'package:bloc/bloc.dart';
import 'package:easy_care/utils/types.dart';
import 'package:meta/meta.dart';


part 'voice_record_event.dart';
part 'voice_record_state.dart';

class VoiceRecordBloc extends Bloc<VoiceRecordEvent, VoiceRecordState> {
  VoiceRecordBloc() : super(const VoiceRecordState()) {
    
    
    //here start recording ,stop recording
   
  }
}
