// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'services_bloc.dart';

@immutable
class ServicesState {
  final List<XFile> images;
  final List<Uint8List> thumbnail;
  final List<File> videoFiles;
  final bool isLoadThumb;
  final bool isLoading;
  final bool started;
  const ServicesState({
    this.images = const [],
    this.thumbnail = const [],
    this.videoFiles = const [],
    this.isLoading = false,
    this.started = false,
    this.isLoadThumb = false,
  });

  

  ServicesState copyWith({
    List<XFile>? images,
    List<Uint8List>? thumbnail,
    List<File>? videoFiles,
    bool? isLoadThumb,
    bool? isLoading,
    bool? started,
  }) {
    return ServicesState(
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
      videoFiles: videoFiles ?? this.videoFiles,
      isLoadThumb: isLoadThumb ?? this.isLoadThumb,
      isLoading: isLoading ?? this.isLoading,
      started: started ?? this.started,
    );
  }
}
