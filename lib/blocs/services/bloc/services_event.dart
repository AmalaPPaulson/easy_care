// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'services_bloc.dart';

@immutable
sealed class ServicesEvent {}

class ImagePickerET extends ServicesEvent {
  final XFile image;
  ImagePickerET({
    required this.image,
  });
}

class VideoPickerET extends ServicesEvent {
  final XFile xfilePick;
  VideoPickerET({
    required this.xfilePick,
  });
}

class ImageDeleteET extends ServicesEvent {
  //final XFile image;
  final int index;
  ImageDeleteET({
    // required this.image,
    required this.index,
  });
}

class VideoDeleteET extends ServicesEvent {
  final int index;
  VideoDeleteET({
    required this.index,
  });
}

class StartServiceApiET extends ServicesEvent {
  final String id;
  final String? description;
  final String?  audio;
  StartServiceApiET({
    required this.id,
     this.description,
      this.audio,
  });
  
}
